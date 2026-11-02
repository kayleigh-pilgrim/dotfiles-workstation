-- Project-aware navigation, alternates, and task commands.
return {
  'tpope/vim-projectionist',

  lazy = false,

  dependencies = {
    'tpope/vim-dispatch',
  },

  init = function()
    vim.g.projectionist_heuristics = {
      -- Laravel applications.
      ['artisan&composer.json'] = {
        ['*'] = {
          start = 'php artisan serve',
          console = 'php artisan tinker',
          dispatch = 'php artisan test',
        },

        ['app/*.php'] = {
          type = 'source',
          alternate = {
            'tests/Unit/{}Test.php',
            'tests/Feature/{}Test.php',
          },
        },

        ['tests/Unit/*Test.php'] = {
          type = 'test',
          alternate = 'app/{}.php',
          dispatch = 'php artisan test {file}',
        },

        ['tests/Feature/*Test.php'] = {
          type = 'test',
          alternate = 'app/{}.php',
          dispatch = 'php artisan test {file}',
        },

        ['app/Actions/*.php'] = {
          type = 'action',
        },

        ['app/Console/Commands/*.php'] = {
          type = 'command',
        },

        ['app/Events/*.php'] = {
          type = 'event',
        },

        ['app/Http/Controllers/*.php'] = {
          type = 'controller',
        },

        ['app/Http/Middleware/*.php'] = {
          type = 'middleware',
        },

        ['app/Http/Requests/*.php'] = {
          type = 'request',
        },

        ['app/Http/Resources/*.php'] = {
          type = 'resource',
        },

        ['app/Jobs/*.php'] = {
          type = 'job',
        },

        ['app/Listeners/*.php'] = {
          type = 'listener',
        },

        ['app/Mail/*.php'] = {
          type = 'mail',
        },

        ['app/Models/*.php'] = {
          type = 'model',
          alternate = {
            'database/factories/{}Factory.php',
            'tests/Unit/Models/{}Test.php',
            'tests/Feature/Models/{}Test.php',
          },
        },

        ['app/Notifications/*.php'] = {
          type = 'notification',
        },

        ['app/Policies/*.php'] = {
          type = 'policy',
        },

        ['app/Providers/*.php'] = {
          type = 'provider',
        },

        ['database/factories/*Factory.php'] = {
          type = 'factory',
          alternate = 'app/Models/{}.php',
        },

        ['database/migrations/*.php'] = {
          type = 'migration',
        },

        ['database/seeders/*.php'] = {
          type = 'seeder',
        },

        ['resources/views/*.blade.php'] = {
          type = 'view',
        },

        ['routes/*.php'] = {
          type = 'route',
        },
      },

      -- Composer packages using the conventional src/ directory.
      ['src/&composer.json'] = {
        ['src/*.php'] = {
          type = 'source',
          alternate = {
            'tests/{}Test.php',
            'tests/Unit/{}Test.php',
            'tests/Feature/{}Test.php',
          },
        },

        ['tests/*Test.php'] = {
          type = 'test',
          alternate = 'src/{}.php',
        },

        ['tests/Unit/*Test.php'] = {
          type = 'test',
          alternate = 'src/{}.php',
        },

        ['tests/Feature/*Test.php'] = {
          type = 'test',
          alternate = 'src/{}.php',
        },
      },

      -- Non-Laravel Composer projects using app/ rather than src/.
      -- The !artisan requirement prevents this from also matching
      -- Laravel applications.
      ['app/&composer.json&!artisan'] = {
        ['app/*.php'] = {
          type = 'source',
          alternate = 'tests/{}Test.php',
        },

        ['tests/*Test.php'] = {
          type = 'test',
          alternate = 'app/{}.php',
        },
      },
    }
  end,
}
