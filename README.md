# extforge-phpdebug
Repository for extforge-phpdebug docker image

```
/php/php-debug # Contains the PHP build
/php/php-src   # Contains the src files for the PHP version that was built
/php/server    # Just a folder that contains a index.php, made for use in seperate image.
/php/logs      # Log folder for PHP, set via php.ini
```
Just use this image to copy PHP to you project.
```
# Copy everything.
COPY --from=fromexo/extforge-phpdebug:php-8.3.0 /php /php
# Set PATH to include the PHP bin files.
ENV PATH="/php/php-debug/bin:$PATH"
```

I welcome suggestions.
