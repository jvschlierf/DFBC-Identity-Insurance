import telegram
from telegram.ext import (
    Updater,
    CommandHandler,
    MessageHandler,
    Filters,
    ConversationHandler,
    CallbackContext,
)
from telegram import ReplyKeyboardMarkup, Update, ReplyKeyboardRemove
import requests
from flask import Flask, request
from credentials import BOT_TOKEN, APP_URL
import logging

logging.basicConfig(format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
                     level=logging.INFO)
logger = logging.getLogger(__name__)

global bot
bot = telegram.Bot(token=BOT_TOKEN)

app = Flask(__name__)

''' States'''
CHOOSING, TYPING_REPLY = range(3)

@app.route('/{}'.format(BOT_TOKEN), methods=['GET', 'POST'])
def start(update: Updater, context: CallbackContext) -> int:

#    chat_id = update.message.chat.id
#    msg_id = update.message.message_id
   text = update.message.text.encode('utf-8').decode()

   reply_keyboard = [['Ownership check', 'NFT', 'Buy/sell property']]
   if request.method == 'POST':
    if text == "/start":
        bot_welcome = "Hello! This is blockchain-based land registry. What would you like to do?"
        update.message.reply_text(bot_welcome, reply_markup=ReplyKeyboardMarkup(reply_keyboard, 
        one_time_keyboard=True))

   return CHOOSING

def regular_choice(update: Update, context: CallbackContext) -> int:
    
    user = update.message.from_user
    text = update.message.text
    logger.info("Choice of %s: %s", user.first_name, text)    

    # context.user_data['choice'] = text
    update.message.reply_text(f'You would like to{text.lower()}? Yes, I would love to hear about that!',
                    reply_markup=ReplyKeyboardRemove())

    return TYPING_REPLY

def done(update: Update, context: CallbackContext) -> int:
    """Display the gathered info and end the conversation."""

    update.message.reply_text("Until next time!")

    return ConversationHandler.END

def handle_message(update, context):
    text = str(update.message.text).lower()
    return text

def error(update, context):
    logger.error(f'Update {update} caused error {context.error}')

def main() -> None:
    """Run the bot."""

    updater = Updater(BOT_TOKEN)
    dispatcher = updater.dispatcher

    # Add conversation handler with the states CHOOSING, TYPING_CHOICE and TYPING_REPLY
    conv_handler = ConversationHandler(
        entry_points=[CommandHandler('start', start)],
        states={
            CHOOSING: [
                MessageHandler(regular_choice
                ),
                # MessageHandler(Filters.regex('^Something else...$'), custom_choice),
            ],
            # TYPING_REPLY: [
            #     MessageHandler(
            #         Filters.text & ~(Filters.command | Filters.regex('^Done$')),
            #         received_information,
            #     )
            # ],
        },
        fallbacks=[MessageHandler(Filters.regex('^Done$'), done)],
    )

    dispatcher.add_handler(conv_handler)


#     dp.add_handler(CommandHandler("start", start))
#     dp.add_handler(CommandHandler("pokedex", pokedex))

    # updater.start_webhook(listen='0.0.0.0',
    #                       port=PORT,
    #                       url_path=BOT_TOKEN, 
    #                       webhook_url = APP_URL + BOT_TOKEN)
    updater.start_polling()
    updater.idle()

@app.route('/set_webhook', methods=['GET', 'POST'])
def set_webhook():
   s = bot.setWebhook('{APP_URL}{HOOK}'.format(URL=APP_URL, HOOK=BOT_TOKEN))
   if s:
       return "webhook setup ok"
   else:
       return "webhook setup failed"

@app.route('/')
def index():
   return '.'

if __name__ == '__main__':
   app.run(threaded=True)