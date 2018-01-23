define (require, exports, module) ->
  $ = window.jQuery
  {getObject} = require 'zooniverse/util'

  attribute = 'data-i18n'
  translationsRoot = 'translations'

  # Basically, 'nav/home': $('[data-i18n="nav"] [data-i18n="home"]')
  elementsMap = {}

  # Store translations so we don't need to download them again.
  languagesCache = {}

  currentLang = ''

  # Set up the elements map.
  for target in $("[#{attribute}]")
    target = $(target)
    continue unless target.find("[#{attribute}]").length is 0

    tree = target.parents("[#{attribute}]").andSelf()
    path = ($(el).attr attribute for el in tree).join '.'

    elementsMap[path] = target

  # Apply a cached translation.
  applyFromCache = (lang) ->
    $('html').attr 'lang', lang
    for path, target of elementsMap
      content = getObject path, languagesCache[lang]
      target.html content if content?

  # Apply a translation, request if not cached.
  translateDocument = (e..., lang) ->
    currentLang = lang
    if lang of languagesCache
      applyFromCache lang
    else
      $.get "#{translationsRoot}/#{lang}.json", (response) ->
        languagesCache[lang] = response
        applyFromCache lang

  translate = (string) ->
    # console.log languagesCache[currentLang]
    throw new Error 'No language selected' unless currentLang
    getObject string, languagesCache[currentLang]

  $(document).on 'request-translation', translateDocument

  module.exports = {translateDocument, translate, elementsMap, languagesCache}
