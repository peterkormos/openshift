package util;

import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.MissingResourceException;
import java.util.ResourceBundle;

import org.apache.log4j.Logger;

public class LanguageUtil {
    public static Logger logger = Logger.getLogger(LanguageUtil.class);
    
    Map<String, ResourceBundle> languages = new HashMap<String, ResourceBundle>(); 

    public ResourceBundle getLanguage(final String language) {
        try {
                if (!languages.containsKey(language)) {
                        languages.put(language,
                                        ResourceBundle.getBundle("language", new Locale(language), new ResourceBundle.Control() {
                                                @Override
                                                public Locale getFallbackLocale(String baseName, Locale locale) {
                                                        return Locale.ROOT;
                                                }

                                        }));
                }
        } catch (final MissingResourceException e) {
                logger.error("getLanguage(): country: " + language, e);

                // cache default language
                languages.put(language, ResourceBundle.getBundle("language", Locale.ROOT));
        }

        logger.trace("getLanguage(): " + language);

        return languages.get(language);
}

}
