
import json
import boto3
from decimal import Decimal

dynamodb = boto3.resource("dynamodb")

TABLE_NAME = "GameScores"



def json_serializer(obj):
    if isinstance(obj, Decimal):
        # Convert whole numbers to int, decimals to float
        if obj % 1 == 0:
            return int(obj)
        return float(obj)

    raise TypeError(
        f"Object of type {type(obj).__name__} is not JSON serializable"
    )


def response(status_code, message, data=None):
    return {
        "statusCode": status_code,
        "body": json.dumps(
            {
                "message": message,
                "data": data or {}
            },
            default=json_serializer
        )
    }


def lambda_handler(event, context):
    table = dynamodb.Table(TABLE_NAME)
    action = event.get("action")

    try:
        # CREATE
        if action == "create":
            gametitle = event.get("gametitle")
            userid = event.get("userid")
            score = event.get("score")

            if not gametitle or not userid or score is None:
                return response(
                    400,
                    "gametitle, userid and score are required"
                )

            table.put_item(
                Item={
                    "GameTitle": gametitle,
                    "UserId": userid,
                    "score": score
                },
                ConditionExpression=(
                    "attribute_not_exists(GameTitle) "
                    "AND attribute_not_exists(UserId)"
                )
            )

            return response(201, "Game score created", {
                "GameTitle": gametitle,
                "UserId": userid,
                "score": score
            })

        # READ
        elif action == "read":
            gametitle = event.get("gametitle")
            userid = event.get("userid")

            if not gametitle or not userid:
                return response(
                    400,
                    "gametitle and userid are required"
                )

            result = table.get_item(
                Key={
                    "GameTitle": gametitle,
                    "UserId": userid
                }
            )

            item = result.get("Item")

            if not item:
                return response(404, "Game score not found")

            return response(200, "Game score retrieved", item)

        # UPDATE
        elif action == "update":
            gametitle = event.get("gametitle")
            userid = event.get("userid")
            score = event.get("score")

            if not gametitle or not userid or score is None:
                return response(
                    400,
                    "gametitle, userid and score are required"
                )

            result = table.update_item(
                Key={
                    "GameTitle": gametitle,
                    "UserId": userid
                },
                UpdateExpression="SET #s = :score",
                ExpressionAttributeNames={
                    "#s": "score"
                },
                ExpressionAttributeValues={
                    ":score": score
                },
                ConditionExpression=(
                    "attribute_exists(GameTitle) "
                    "AND attribute_exists(UserId)"
                ),
                ReturnValues="ALL_NEW"
            )

            return response(
                200,
                "Game score updated",
                result.get("Attributes", {})
            )

        # DELETE ONE
        elif action == "delete":
            gametitle = event.get("gametitle")
            userid = event.get("userid")

            if not gametitle or not userid:
                return response(
                    400,
                    "gametitle and userid are required"
                )

            table.delete_item(
                Key={
                    "GameTitle": gametitle,
                    "UserId": userid
                },
                ConditionExpression=(
                    "attribute_exists(GameTitle) "
                    "AND attribute_exists(UserId)"
                )
            )

            return response(200, "Game score deleted", {
                "GameTitle": gametitle,
                "UserId": userid
            })

        # DELETE ALL
        elif action == "delete_all":
            scan_kwargs = {
                "ProjectionExpression": "GameTitle, UserId"
            }
            deleted_count = 0

            with table.batch_writer() as batch:
                while True:
                    result = table.scan(**scan_kwargs)

                    for item in result.get("Items", []):
                        batch.delete_item(
                            Key={
                                "GameTitle": item["GameTitle"],
                                "UserId": item["UserId"]
                            }
                        )
                        deleted_count += 1

                    last_key = result.get("LastEvaluatedKey")
                    if not last_key:
                        break

                    scan_kwargs["ExclusiveStartKey"] = last_key

            return response(200, "All game scores deleted", {
                "deleted_count": deleted_count
            })

        else:
            return response(
                400,
                "Invalid action. Use create, read, update, delete or delete_all."
            )

    except dynamodb.meta.client.exceptions.ConditionalCheckFailedException:
        return response(
            404,
            "Item already exists or does not exist for this operation"
        )

    except Exception:
        print("Unexpected error processing game score request")
        raise
