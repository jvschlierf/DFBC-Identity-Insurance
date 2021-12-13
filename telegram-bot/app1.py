import telegram
from telegram.ext import Updater, CommandHandler, CallbackContext
import logging
# import redis
import re
from flask import Flask, request
from credentials import BOT_TOKEN, REDIS_URI, BOT_USER_NAME, APP_URL
import logging

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                     level=logging.INFO)

global bot
global TOKEN
TOKEN = BOT_TOKEN
bot = telegram.Bot(token=TOKEN)

# r = redis.from_url(REDIS_URI) # connection to the databse
# db_keys = r.keys(pattern='*')   # allows us to fetch data

app = Flask(__name__)


# def start(update: Update, context: CallbackContext) -> int:
#     """Starts the conversation"""
#     reply_keyboard = [['Boy', 'Girl', 'Other']]

#     update.message.reply_text(
#         '"Hello! This is blockchain-based land registry". Please introduce yourself.'
#         reply_markup=ReplyKeyboardMarkup(
#             reply_keyboard, one_time_keyboard=True, input_field_placeholder='Boy or Girl?'
#         ),
#     )

#     return GENDER

@app.route('/{}'.format(TOKEN), methods=['POST'])
def start():
   update = telegram.Update.de_json(request.get_json(force=True), bot)

   chat_id = update.message.chat.id
   msg_id = update.message.message_id

   text = update.message.text.encode('utf-8').decode()
   print("got text message :", text)
   if text == "/start":
       bot_welcome = "Hello! This is blockchain-based land registry"
       bot.sendMessage(chat_id=chat_id, text=bot_welcome, reply_to_message_id=msg_id)

   else:
       try:
           text = re.sub(r"\W", "_", text)
           # create the api link for the avatar based on http://avatars.adorable.io/
           url = "https://api.adorable.io/avatars/285/{}.png".format(text.strip())
           # reply with a photo to the name the user sent,
           # note that you can send photos by url and telegram will fetch it for you
           bot.sendPhoto(chat_id=chat_id, photo=url, reply_to_message_id=msg_id)
       except Exception:
           # if things went wrong
           bot.sendMessage(chat_id=chat_id, text="There was a problem in the name you used, please enter different name", reply_to_message_id=msg_id)

   return 'ok'


# updater = Updater(token=BOT_TOKEN, use_context=True)
# dispatcher = updater.dispatcher

# # j = updater.job_queue

# def start(update, context):
#     user_id = update.message.from_user.id
#     user_name = update.message.from_user.name
#     r.set(user_name, user_id)

#     message = "Hello! This is blockchain-based land registry"
#     context.bot.send_message(chat_id=update.effective_chat.id, text=message)

# dispatcher.add_handler(CommandHandler("start", start))
# updater.start_polling()

@app.route('/set_webhook', methods=['GET', 'POST'])
def set_webhook():
   s = bot.setWebhook('{APP_URL}{HOOK}'.format(URL=APP_URL, HOOK=TOKEN))
   if s:
       return "webhook setup ok"
   else:
       return "webhook setup failed"

@app.route('/')
def index():
   return '.'

if __name__ == '__main__':
   app.run(threaded=True)