#!/usr/bin/env bash

if [[ $# -eq 0 ]] ; then
    read -r -p "Domain: " DOMAIN
else
    DOMAIN=$1
fi

if [[ -z "$DOMAIN" ]]; then
    echo "Domain may not be empty." >&2
    exit 1
fi

SITE_USER=`echo ${DOMAIN} | awk -F'.' '{print $1}'`

DIR="${HOME}/Code/${DOMAIN}"
if [[ -e "${DIR}" ]]; then
    echo "Project directory already exists: ${DIR}" >&2
    exit 1
fi

cd ${HOME}/Code
laravel new ${DOMAIN}
cd ${DIR}

npm install && npm run build
php artisan migrate

composer require laravel/pint barryvdh/laravel-debugbar pestphp/pest-plugin-browser larastan/larastan --dev
composer require laravel/horizon laravel/nightwatch spatie/laravel-sitemap
php artisan horizon:install
npm install --save-dev prettier-plugin-blade prettier prettier-plugin-tailwindcss playwright@latest eslint eslint-config-prettier typescript-eslint @eslint/js globals typescript
npx playwright install chromium

echo -e '
{
    "semi": true,
    "singleQuote": true,
    "tabWidth": 4,
    "printWidth": 120,
    "trailingComma": "es5",
    "plugins": ["prettier-plugin-blade", "prettier-plugin-tailwindcss"],
    "tailwindFunctions": ["clsx", "cn", "cva"],
    "tailwindStylesheet": "resources/css/app.css",
    "overrides": [
        {
            "files": ["*.blade.php"],
            "options": {
                "parser": "blade"
            }
        },
        {
            "files": ["*.json", "*.yml", "*.yaml"],
            "options": {
                "tabWidth": 2
            }
        }
    ]
}
' > .prettierrc

echo -e '
node_modules
vendor
storage
bootstrap/cache
.env
.env.*
!.env.example
*.log
npm-debug.log*
yarn-debug.log*
pnpm-debug.log*
composer.lock
package-lock.json
yarn.lock
pnpm-lock.yaml
bun.lockb
bun.lock
*.min.js
*.min.css
.idea
.vscode
.DS_Store
Thumbs.db
coverage
.phpunit.cache
.pest
.phpactor.json
.php-cs-fixer.cache
.pint.cache
dist
public/build
public/hot
.git
resources/views/pages/settings/⚡two-factor-setup-modal.blade.php
tests/Browser/Screenshots
' > .prettierignore

echo -e "
import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import prettier from 'eslint-config-prettier';
import globals from 'globals';

export default tseslint.config(
    {
        ignores: [
            'vendor/**',
            'node_modules/**',
            'public/build/**',
            'public/hot/**',
            'storage/**',
            'bootstrap/cache/**',
            'bootstrap/ssr/**',
            'tailwind.config.js',
            'resources/js/actions/**',
            'resources/js/components/ui/**',
            'resources/js/routes/**',
        ],
    },
    eslint.configs.recommended,
    ...tseslint.configs.recommended,
    {
        files: ['resources/js/**/*.{js,ts}', 'vite.config.{js,ts}', 'eslint.config.js'],

        languageOptions: {
            ecmaVersion: 'latest',
            sourceType: 'module',
            globals: {
                ...globals.browser,
                ...globals.node,

                Livewire: 'readonly',
                Alpine: 'readonly',
            },
        },

        rules: {
            // TypeScript
            '@typescript-eslint/no-unused-vars': [
                'warn',
                {
                    argsIgnorePattern: '^_',
                    varsIgnorePattern: '^_',
                    caughtErrorsIgnorePattern: '^_',
                },
            ],
            '@typescript-eslint/no-explicit-any': 'warn',

            // General
            'no-console': ['warn', { allow: ['warn', 'error'] }],
            'no-debugger': 'warn',
            'no-var': 'error',
            'prefer-const': 'warn',
            eqeqeq: ['error', 'smart'],
            curly: ['error', 'all'],
        },
    },
    prettier
);
" > eslint.config.js

grep -qxF 'tests/Browser/Screenshots' .gitignore || echo 'tests/Browser/Screenshots' >> .gitignore
grep -qxF 'tests/.pest/snapshots' .gitignore || echo 'tests/.pest/snapshots' >> .gitignore

echo -e "
#!/usr/bin/env bash
cd /var/www/${DOMAIN}

git pull

composer install --no-dev --optimize-autoloader

npm ci
npm run build

php artisan optimize:clear
php artisan migrate --force
php artisan db:seed --force
php artisan site:flush-cache
php artisan optimize

php artisan horizon:terminate
sudo supervisorctl restart ${SITE_USER}-nightwatch

chown -R ${SITE_USER}:${SITE_USER} /var/www/${DOMAIN}
sudo systemctl reload php8.5-fpm
sudo systemctl reload nginx
" > pull.sh

npm pkg set scripts.format="prettier . --write"
npm pkg set scripts.lint="eslint . --fix"

php -r '
$file = "composer.json";

$json = json_decode(file_get_contents($file), true, flags: JSON_THROW_ON_ERROR);

$json["scripts"] ??= [];

$json["scripts"]["analyse"] = "phpstan analyse";

$json["scripts"]["l"] = [
    "npm run format",
    "npm run lint",
    "pint --parallel",
];

$json["scripts"]["t"] = [
    "@php artisan config:clear --ansi",
    "@php artisan test --parallel",
];

$json["scripts"]["lt"] = [
    "@l",
    "@t",
];

file_put_contents(
    $file,
    json_encode($json, JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES) . PHP_EOL
);
'

