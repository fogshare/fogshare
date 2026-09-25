#
# Fogshare - CPAN Dependency Specification
#
# Copyright (c) 2026 Fogshare Contributors
# Licensed under the MIT License.
#

# Core Web Framework & Plugins
requires 'Mojolicious',                 '>= 9.0';
requires 'Mojolicious::Plugin::I18N';

# PSGI Production Application Server
requires 'Starman',                     '>= 0.4016';

# Security, Cryptography & I18N
requires 'Digest::SHA';
requires 'I18N::LangTags';

# Archive Extraction & Filesystem Utilities
requires 'Archive::Zip';
requires 'File::Copy::Recursive';

# Optional Performance & Transport Recommendations
recommends 'IO::Socket::SSL',           '>= 2.009';
recommends 'Net::SSLeay',               '>= 1.90';