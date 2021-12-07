import telegram
from telegram.ext import Updater, CommandHandler, CallbackContext
import logging
import redis
from credentials import BOT_TOKEN, REDIS_URI

telegram_bot_token = BOT_TOKEN
r = redis.from_url(REDIS_URI) # connection to the databse
db_keys = r.keys(pattern='*')   # allows us to fetch data

updater = Updater(token=telegram_bot_token, use_context=True)
dispatcher = updater.dispatcher

# j = updater.job_queue

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO)

# def start(update, context):
#     chat_id = update.effective_chat.id
#     context.bot.send_message(chat_id=chat_id, text="Hello! This is blockchain-based land registry")

def start(update, context):
    user_id = update.message.from_user.id
    user_name = update.message.from_user.name
    r.set(user_name, user_id)

    message = "Hello! This is blockchain-based land registry"
    context.bot.send_message(chat_id=update.effective_chat.id, text=message)

dispatcher.add_handler(CommandHandler("start", start))
updater.start_polling()