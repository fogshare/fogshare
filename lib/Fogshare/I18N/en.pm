package Fogshare::I18N::en;
#
# Fogshare - English Lexicon (Default Fallback)
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

use Mojo::Base 'Fogshare::I18N';

# English acts as the fallback default lexicon.
# With _AUTO enabled, missing keys default directly to the key string itself.
our %Lexicon = (
    _AUTO => 1,
);

1;