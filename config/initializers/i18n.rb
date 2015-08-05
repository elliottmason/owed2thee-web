module I18n
  module Backend
    class SelfAware < Simple
      def resolve(locale, object, subject, options = {})
        return subject if options[:resolve] == false
        result = catch(:exception) do
          case subject
          when Hash
            keys = subject.except(:string).keys
            interpolations = keys.each_with_object({}) do |key, memo|
              memo[key] = resolve(locale, subject[key], subject[key], options)
            end
            I18n.translate(:"#{object}.string", interpolations.merge(options))
          when Symbol
            I18n.translate(subject, options.merge(locale: locale, throw: true))
          when Proc
            date_or_time = options.delete(:object) || object
            resolve(locale, object, subject.call(date_or_time, options))
          else
            subject
          end
        end
        result unless result.is_a?(MissingTranslation)
      end
    end
  end
end

I18n.backend = I18n::Backend::SelfAware.new
