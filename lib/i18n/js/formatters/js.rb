require "i18n/js/formatters/base"

module I18n
  module JS
    module Formatters
      class JS < Base
        def format(translations)
          contents = header
          translations.each do |locale, translations_for_locale|
            contents << line(locale, format_json(translations_for_locale))
          end
          contents << (@suffix || '')
        end

        protected

        def header
          text = @prefix || ''
          text + %(#{@namespace}.translations || (#{@namespace}.translations = {});\n)
        end

        def line(locale, translations)
          json_literal = @pretty_print ? translations : %(JSON.parse('#{translations.gsub("'"){"\\'"}}'))
          if @js_extend
            %(#{@namespace}.translations["#{locale}"] = I18n.extend((#{@namespace}.translations["#{locale}"] || {}), #{json_literal});\n)
          else
            %(#{@namespace}.translations["#{locale}"] = #{json_literal};\n)
          end
        end
      end
    end
  end
end
