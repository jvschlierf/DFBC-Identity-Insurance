import re
import logging
import requests
import telegram
from telegram.ext import (
    Updater,
    CommandHandler,
    MessageHandler,
    Filters,
    ConversationHandler,
    CallbackContext,
)
from credentials import BOT_TOKEN, BOT_USER_NAME, APP_URL
import os

PORT = int(os.environ.get('PORT', 8443))

global bot
bot = telegram.Bot(token=BOT_TOKEN)

logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s', level=logging.INFO
)

logger = logging.getLogger(__name__)


def start(update, context):
    """Send a message when the command /start is issued."""
    update.message.reply_text(
        'Hello, my Name is Professor Oak! \n' 
        'I can give you more information on Pokemon!'
    )

def webhook(request):
    if request.method == "POST":
        update = telegram.Update.de_json(request.get_json(force=True), bot)
        chat_id = update.message.chat.id
        bot.sendMessage(chat_id=chat_id, text=update.message.text)
    return "ok"

# def pokedex(update, context): 
#     """ Searches the Pokemon API for more information and return the data """

#     # Get the pokemon from the command and check if it's not empty

#     pokemon_query = update.message.text.replace('/pokedex', '').replace(" ", "").lower()

#     if len(pokemon_query) == 0:
#         update.message.reply_text(
#             'Please add a pokemon name to your command \n'
#             'Example: /pokedex Pikachu' 
#         ) 
#     else:

#         # Call the API
#         response = requests.get('https://pokeapi.co/api/v2/pokemon-species/' + pokemon_query +'/')

#         # Check if the data is found by the server
#         if response.status_code == 404:
#             update.message.reply_text(
#                 "I could not find the pokemon: {pokemon_query}".format(pokemon_query=pokemon_query)
#             )     
#         else:
#             # Get the data from the response
#             pokemon_data = response.json()

#             pokemon_id = pokemon_data['id']
#             pokemon_name = pokemon_data['name'].capitalize()
#             pokemon_desc = "NO DESCRIPTION FOUND"
#             pokemon_image = "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/" + str(pokemon_id) + ".png"

#             for desc in pokemon_data['flavor_text_entries']: 
#                 if desc['language']['name'] == 'en':
#                     pokemon_desc = desc['flavor_text'].replace('\n', ' ')

#             # Send a message back to the user
#             update.message.reply_text(
#                 "[{pokemon_id}] {pokemon_name} \n\n{pokemon_desc}\n{pokemon_image}".format(
#                     pokemon_id=pokemon_id, pokemon_name=pokemon_name, pokemon_desc=pokemon_desc, 
#                     pokemon_image=pokemon_image
#                 )
#             ) 

def main():
    updater = Updater(BOT_TOKEN, use_context=True)
    dp = updater.dispatcher

    # on different commands - answer in Telegram
    dp.add_handler(CommandHandler("start", start))
    # dp.add_handler(CommandHandler("pokedex", pokedex))

    updater.start_webhook(listen="0.0.0.0",
                          port=int(PORT),
                          url_path=BOT_TOKEN, 
                          webhook_url = APP_URL + BOT_TOKEN)
    # updater.bot.setWebhook(APP_URL + BOT_TOKEN)

    updater.idle()

if __name__ == '__main__':
    main()