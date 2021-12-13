import redis
from credentials import BOT_TOKEN, REDIS_URI

r = redis.from_url(REDIS_URI)

db_keys = r.keys(pattern="*")
print((len(db_keys)))
for single in db_keys:
    chat_id = r.get(single).decode("UTF-8")
    print(single.decode("UTF-8"), ": ", chat_id)

    