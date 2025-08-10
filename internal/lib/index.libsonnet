local versions = {
  [std.split(step.uses, '@')[0]]: std.split(step.uses, '@')[1]
  for step in std.parseYaml(importstr './.github/workflows/versions.yml').jobs.version.steps
};

local uses(action) = {
  uses: '%s@%s' % [action, versions[action]],
};

local directory(providers) = {
  '.github': {
    'dependabot.yml': std.manifestYamlDoc({
      version: 2,
      updates: [
        {
          'package-ecosystem': 'gomod',
          directory: '/',
          schedule: { interval: 'daily' },
        },
        {
          'package-ecosystem': 'github-actions',
          directory: '/',
          schedule: { interval: 'daily' },
        },
      ] + [
        {
          'package-ecosystem': 'terraform',
          directory: '/providers/%(source)s' % provider,
          schedule: { interval: 'daily' },
        }
        for provider in providers
      ],
    }),
    workflows: {
      ['test-%s.yml' % std.strReplace(std.strReplace(provider.source, '/', '-'), '.', '-')]: std.manifestYamlDoc({
        name: 'Test %(source)s' % provider,
        on: {
          pull_request: {
            paths: ['internal', 'providers/%(source)s/**' % provider],
          },
          workflow_dispatch: {},
        },
        permissions: {
          contents: 'read',
        },
        jobs: {
          test: {
            name: 'Test',
            'runs-on': 'ubuntu-latest',
            'timeout-minutes': 5,
            steps: [
              uses('actions/checkout'),
              uses('hashicorp/setup-terraform'),
              uses('extractions/setup-just'),
              uses('actions/setup-go') {
                with: {
                  'go-version-file': 'go.mod',
                  cache: true,
                },
              },
              uses('jaxxstorm/action-install-gh-release') {
                with: {
                  repo: 'marcbran/jpoet',
                },
              },
              {
                name: 'Run tests',
                run: 'just gen-provider ./providers/%(source)s' % provider,
              },
            ],
          },
        },
      })
      for provider in providers
    } {
      ['push-%s.yml' % std.strReplace(std.strReplace(provider.source, '/', '-'), '.', '-')]: std.manifestYamlDoc({
        name: 'Push %(source)s' % provider,
        on: {
          workflow_dispatch: {},
          push: {
            branches: ['main'],
            paths: ['internal', 'providers/%(source)s/**' % provider],
          },
        },
        permissions: {
          contents: 'read',
        },
        jobs: {
          push: {
            name: 'Push',
            'runs-on': 'ubuntu-latest',
            'timeout-minutes': 5,
            steps: [
              uses('actions/checkout'),
              uses('hashicorp/setup-terraform'),
              uses('extractions/setup-just'),
              uses('actions/setup-go') {
                with: {
                  'go-version-file': 'go.mod',
                  cache: true,
                },
              },
              uses('jaxxstorm/action-install-gh-release') {
                with: {
                  repo: 'marcbran/jpoet',
                },
              },
              {
                name: 'Set Git config',
                run: |||
                  git config --global user.name "${{ github.actor }}"
                  git config --global user.email "${{ github.actor_id }}+${{ github.actor }}@users.noreply.github.com"
                |||,
              },
              {
                name: 'Push',
                run: 'just push-provider ./providers/%(source)s' % provider,
                env: {
                  GIT_PRIVATE_KEY: '${{ secrets.GIT_PRIVATE_KEY }}',
                },
              },
            ],
          },
        },
      })
      for provider in providers
    },
  },
};

directory
