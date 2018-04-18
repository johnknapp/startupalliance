#https://cookieconsent.insites.com
window.addEventListener 'load', ->
  window.cookieconsent.initialise
    'palette':
      'popup':
        'background': '#f4f4f4'
        'text': '#1b4995'
      'button':
        'background': '#99c7e3'
        'text': '#1b4995'
    'position': 'bottom'
    'content':
      'message': 'We use cookies to provide a secure and effective experience while you’re here.'
      'dismiss': 'I accept'
      'link': 'Learn about cookies'
  return