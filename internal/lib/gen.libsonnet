local j = import 'jsonnet/main.libsonnet';

local build = j.LocalBind('build', j.Object([
  j.FieldFunction(
    'expression',
    [j.Parameter('val')],
    j.If(
      j.Eq(j.Std.type(j.Var('val')), j.String('object')),
      j.If(
        j.Std.objectHas(j.Var('val'), j.String('_')),
        j.If(
          j.Std.objectHas(j.Member(j.Var('val'), '_'), j.String('ref')),
          j.Member(j.Member(j.Var('val'), '_'), 'ref'),
          j.String('"%s"', j.Array([j.Member(j.Member(j.Var('val'), '_'), 'str')]))
        ).fodder(j.Fodder.LineEnd()).thenFodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
        j.String(
          '{%s}',
          j.Array([j.Std.join(
            j.String(','),
            j.Std.map(
              j.Function([j.Parameter('key')], j.String('%s:%s', j.Array([
                j.Apply(j.Member(j.Self, 'expression'), [j.Var('key')]),
                j.Apply(j.Member(j.Self, 'expression'), [j.Index(j.Var('val'), j.Var('key'))]),
              ]))),
              j.Std.objectFields(j.Var('val'))
            )
          )])
        ),
      ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
      j.If(
        j.Eq(j.Std.type(j.Var('val')), j.String('array')),
        j.String(
          '[%s]',
          j.Array([j.Std.join(
            j.String(','),
            j.Std.map(
              j.Function([j.Parameter('element')], j.Apply(j.Member(j.Self, 'expression'), [j.Var('element')])),
              j.Var('val')
            )
          )])
        ),
        j.If(
          j.Eq(j.Std.type(j.Var('val')), j.String('string')),
          j.String('"%s"', j.Array([j.Var('val')])),
          j.String('"%s"', j.Array([j.Var('val')]))
        ).elseFodder(j.Fodder.LineEnd()),
      ).elseFodder(j.Fodder.LineEnd()),
    ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
  ),
  j.FieldFunction(
    'template',
    [j.Parameter('val')],
    j.If(
      j.Eq(j.Std.type(j.Var('val')), j.String('object')),
      j.If(
        j.Std.objectHas(j.Var('val'), j.String('_')),
        j.If(
          j.Std.objectHas(j.Member(j.Var('val'), '_'), j.String('ref')),
          j.Std.strReplace(j.Apply(j.Member(j.Self, 'string'), [j.Var('val')]), j.String('\\n'), j.String('\\\\n')),
          j.Member(j.Member(j.Var('val'), '_'), 'str')
        ).fodder(j.Fodder.LineEnd()).thenFodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
        j.Std.mapWithKey(j.Function([j.Parameter('key'), j.Parameter('value')], j.Apply(j.Member(j.Self, 'template'), [j.Var('value')])), j.Var('val'))
      ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
      j.If(
        j.Eq(j.Std.type(j.Var('val')), j.String('array')),
        j.Std.map(j.Function([j.Parameter('element')], j.Apply(j.Member(j.Self, 'template'), [j.Var('element')])), j.Var('val')),
        j.If(
          j.Eq(j.Std.type(j.Var('val')), j.String('string')),
          j.Std.strReplace(j.Apply(j.Member(j.Self, 'string'), [j.Var('val')]), j.String('\\n'), j.String('\\\\n')),
          j.Var('val')
        ).elseFodder(j.Fodder.LineEnd()),
      ).elseFodder(j.Fodder.LineEnd()),
    ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
  ),
  j.FieldFunction(
    'string',
    [j.Parameter('val')],
    j.If(
      j.Eq(j.Std.type(j.Var('val')), j.String('object')),
      j.If(
        j.Std.objectHas(j.Var('val'), j.String('_')),
        j.If(
          j.Std.objectHas(j.Member(j.Var('val'), '_'), j.String('ref')),
          j.String('${%s}', j.Array([j.Member(j.Member(j.Var('val'), '_'), 'ref')])),
          j.Member(j.Member(j.Var('val'), '_'), 'str'),
        ).fodder(j.Fodder.LineEnd()).thenFodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
        j.String('${%s}', j.Array([j.Apply(j.Member(j.Self, 'expression'), [j.Var('val')])]))
      ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
      j.If(
        j.Eq(j.Std.type(j.Var('val')), j.String('array')),
        j.String('${%s}', j.Array([j.Apply(j.Member(j.Self, 'expression'), [j.Var('val')])])),
        j.If(
          j.Eq(j.Std.type(j.Var('val')), j.String('string')),
          j.Var('val'),
          j.Var('val')
        ).elseFodder(j.Fodder.LineEnd()),
      ).elseFodder(j.Fodder.LineEnd()),
    ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
  ),
  j.FieldFunction(
    'blocks',
    [j.Parameter('val')],
    j.If(
      j.Eq(j.Std.type(j.Var('val')), j.String('object')),
      j.If(
        j.Std.objectHas(j.Var('val'), j.String('_')),
        j.If(
          j.Std.objectHas(j.Member(j.Var('val'), '_'), j.String('blocks')),
          j.Member(j.Member(j.Var('val'), '_'), 'blocks'),
          j.If(
            j.Std.objectHas(j.Member(j.Var('val'), '_'), j.String('block')),
            j.Object([
              j.Field(j.Member(j.Member(j.Var('val'), '_'), 'ref'), j.Member(j.Member(j.Var('val'), '_'), 'block')),
            ]),
            j.Object([]),
          ).fodder(j.Fodder.LineEnd()).thenFodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
        ).fodder(j.Fodder.LineEnd()).thenFodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
        j.Std.foldl(
          j.Function([j.Parameter('acc'), j.Parameter('val')], j.Std.mergePatch(j.Var('acc'), j.Var('val'))).fodder(j.Fodder.LineEnd()),
          j.Std.map(
            j.Function([j.Parameter('key')], j.Apply(j.Member(j.Var('build'), 'blocks'), [j.Index(j.Var('val'), j.Var('key'))])),
            j.Std.objectFields(j.Var('val'))
          ).fodder(j.Fodder.LineEnd()),
          j.Object([]).fodder(j.Fodder.LineEnd())
        )
      ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
      j.If(
        j.Eq(j.Std.type(j.Var('val')), j.String('array')),
        j.Std.foldl(
          j.Function([j.Parameter('acc'), j.Parameter('val')], j.Std.mergePatch(j.Var('acc'), j.Var('val'))).fodder(j.Fodder.LineEnd()),
          j.Std.map(
            j.Function([j.Parameter('element')], j.Apply(j.Member(j.Var('build'), 'blocks'), [j.Var('element')])),
            j.Var('val')
          ).fodder(j.Fodder.LineEnd()),
          j.Object([]).fodder(j.Fodder.LineEnd())
        ),
        j.Object([]),
      ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
    ).fodder(j.Fodder.LineEnd()).elseFodder(j.Fodder.LineEnd()),
  ),
]).closeFodder(j.Fodder.LineEnd()));

local providerTemplate = j.LocalFunctionBind('providerTemplate', [j.Parameter('provider'), j.Parameter('requirements'), j.Parameter('rawConfiguration'), j.Parameter('configuration')], j.Object([
  j.FieldLocal('providerRequirements', j.Object([j.Field(j.String('terraform.required_providers.%s', j.Array([j.Var('provider')])), j.Var('requirements'))])),
  j.FieldLocal(
    'providerAlias',
    j.If(
      j.Eq(j.Var('configuration'), j.Null),
      j.Null,
      j.Std.get(j.Var('configuration'), j.String('alias')).default(j.Null)
    ),
  ),
  j.FieldLocal(
    'providerConfiguration',
    j.If(
      j.Eq(j.Var('configuration'), j.Null),
      j.Object([
        j.Field('_', j.Object([
          j.Field('refBlock', j.Object([])),
          j.Field('blocks', j.Array([])),
        ])),
      ]),
      j.Object([
        j.Field('_', j.Object([
          j.FieldLocal('_', j.Self),
          j.Field('ref', j.String('%s.%s', j.Array([j.Var('provider'), j.Member(j.Var('configuration'), 'alias')]))),
          j.Field('refBlock', j.Object([
            j.Field('provider', j.Member(j.Var('_'), 'ref')),
          ]).closeFodder(j.Fodder.LineEnd())),
          j.Field('block', j.Object([
            j.Field('provider', j.Object([
              j.Field('provider', j.Std.prune(j.Var('configuration'))),
            ]).closeFodder(j.Fodder.LineEnd())),
          ]).closeFodder(j.Fodder.LineEnd())),
          j.Field(
            'blocks',
            j.Add(j.Apply(j.Member(j.Var('build'), 'blocks'), [j.Var('rawConfiguration')]), j.Object([
              j.Field(j.Member(j.Var('_'), 'ref'), j.Member(j.Var('_'), 'block')),
            ]).closeFodder(j.Fodder.LineEnd()))
          ),
        ]).closeFodder(j.Fodder.LineEnd())),
      ]).closeFodder(j.Fodder.LineEnd()),
    ),
  ),
  j.FieldFunction('blockType', [j.Parameter('blockType')], j.Object([
    j.FieldLocal(
      'blockTypePath',
      j.If(
        j.Eq(j.Var('blockType'), j.String('resource')),
        j.Array([]),
        j.Array([j.String('data')])
      )
    ),
    j.FieldFunction('resource', [j.Parameter('type'), j.Parameter('name')], j.Object([
      j.FieldLocal('resourceType', j.Std.substr(j.Var('type'), j.Add(j.Std.length(j.Var('provider')), j.Number('1')), j.Std.length(j.Var('type')))),
      j.FieldLocal('resourcePath', j.Add(j.Var('blockTypePath'), j.Array([j.Var('type'), j.Var('name')]))),
      j.FieldFunction('_', [j.Parameter('rawBlock'), j.Parameter('block')], j.Object([
        j.FieldLocal('_', j.Self),
        j.FieldLocal('metaBlock', j.Object([
          j.Field(
            j.String(attributeName),
            j.Apply(j.Member(j.Var('build'), 'template'), [
              j.Std.get(j.Var('rawBlock'), j.String(attributeName)).default(j.Null),
            ])
          )
          // TODO depends_on needs to be a static list expression
          for attributeName in ['depends_on', 'count', 'for_each']
        ]).closeFodder(j.Fodder.LineEnd())),
        j.Field(
          'type',
          j.If(
            j.Std.objectHas(j.Var('rawBlock'), j.String('for_each')),
            j.String('map'),
            j.If(
              j.Std.objectHas(j.Var('rawBlock'), j.String('count')),
              j.String('list'),
              j.String('object'),
            )
          )
        ),
        j.Field('provider', j.Var('provider')),
        j.Field('providerAlias', j.Var('providerAlias')),
        j.Field('resourceType', j.Var('resourceType')),
        j.Field('name', j.Var('name')),
        j.Field('ref', j.Std.join(j.String('.'), j.Var('resourcePath'))),
        j.Field('block', j.Object([
          j.Field(j.Var('blockType'), j.Object([
            j.Field(j.Var('type'), j.Object([
              j.Field(j.Var('name'), j.Std.prune(j.Add(j.Add(j.Member(j.Member(j.Var('providerConfiguration'), '_'), 'refBlock'), j.Var('metaBlock')), j.Var('block')))),
            ]).closeFodder(j.Fodder.LineEnd())),
          ]).closeFodder(j.Fodder.LineEnd())),
        ]).closeFodder(j.Fodder.LineEnd())),
        j.Field(
          'blocks',
          j.Add(
            j.Add(j.Apply(j.Member(j.Var('build'), 'blocks'), [j.Add(j.Array([j.Var('providerConfiguration')]), j.Array([j.Var('rawBlock')]))]), j.Var('providerRequirements')),
            j.Object([
              j.Field(j.Member(j.Var('_'), 'ref'), j.Member(j.Var('_'), 'block')),
            ])
          )
        ),
      ]).closeFodder(j.Fodder.LineEnd())),
      j.FieldFunction('field', [j.Parameter('blocks'), j.Parameter('fieldName')], j.Object([
        j.FieldLocal('fieldPath', j.Add(j.Var('resourcePath'), j.Array([j.Var('fieldName')]))),
        j.Field('_', j.Object([
          j.Field('ref', j.Std.join(j.String('.'), j.Var('fieldPath'))),
          j.Field('blocks', j.Var('blocks')),
        ]).closeFodder(j.Fodder.LineEnd())),
      ]).closeFodder(j.Fodder.LineEnd())),
    ]).closeFodder(j.Fodder.LineEnd())),
  ]).closeFodder(j.Fodder.LineEnd())),
  j.FieldFunction('func', [j.Parameter('name'), j.Parameter('parameters', j.Array([]))], j.Object([
    j.FieldLocal('parameterString', j.Std.join(
      j.String(', '),
      j.ArrayComp(
        j.Apply(j.Member(j.Var('build'), 'expression'), [j.Var('parameter')]),
        [j.ForSpec('parameter', j.Var('parameters'))]
      )
    )),
    j.Field(j.String('_'), j.Object([
      j.Field('ref', j.String('provider::%s::%s(%s)', j.Array([j.Var('provider'), j.Var('name'), j.Var('parameterString')]))),
      j.Field(
        'blocks',
        j.Add(j.Apply(j.Member(j.Var('build'), 'blocks'), [j.Add(j.Array([j.Var('providerConfiguration')]), j.Array([j.Var('parameters')]))]), j.Var('providerRequirements'))
      ),
    ]).closeFodder(j.Fodder.LineEnd())),
  ]).closeFodder(j.Fodder.LineEnd())),
]).closeFodder(j.Fodder.LineEnd()));

local resourceBlock(provider, type, name, resource) =
  local attributes = std.get(resource.block, 'attributes', {});
  j.FieldFunction(
    j.String(std.substr(name, std.length(provider) + 1, std.length(name))),
    [j.Parameter('name'), j.Parameter('block')],
    j.Object([
      j.FieldLocal('resource', j.Apply(j.Member(j.Var('blockType'), 'resource'), [j.String(name), j.Var('name')])),
      j.Field(j.String('_'), j.Apply(j.Member(j.Var('resource'), '_'), [
        j.Var('block'),
        j.Object(std.flattenArrays([
          local attribute = attributes[attributeName];
          // TODO there are some providers with schemas where the computed property is actually required in resources
          //          if std.get(attribute, 'computed', false) then [] else
          [
            j.Field(
              j.String(attributeName),
              j.Apply(j.Member(j.Var('build'), 'template'), [
                if std.get(attribute, 'required', false)
                then j.Index(j.Var('block'), j.String(attributeName))
                else j.Std.get(j.Var('block'), j.String(attributeName)).default(j.Null),
              ])
            ),
          ]
          for attributeName in std.objectFields(attributes)
        ])).closeFodder(j.Fodder.LineEnd()),
      ])),
    ] + [
      j.Field(j.String(attributeName), j.Apply(j.Member(j.Var('resource'), 'field'), [j.Member(j.Member(j.Self, '_'), 'blocks'), j.String(attributeName)]))
      for attributeName in std.objectFields(attributes)
    ]).closeFodder(j.Fodder.LineEnd())
  );

local resourceBlocks(provider, type, resourceSchemas) = if std.length(std.objectFields(resourceSchemas)) == 0 then [] else [
  j.Field(j.String(type), j.Object([
    j.FieldLocal('blockType', j.Apply(j.Member(j.Var('provider'), 'blockType'), [j.String(type)])),
  ] + [
    resourceBlock(provider, type, name, resourceSchemas[name])
    for name in std.objectFields(resourceSchemas)
  ]).closeFodder(j.Fodder.LineEnd())),
];

local functionBlock(name, Function) =
  local parameters = Function.parameters + if std.objectHas(Function, 'variadic_parameter') then [Function.variadic_parameter] else [];
  j.FieldFunction(
    j.String(name),
    [j.Parameter(parameter.name) for parameter in parameters],
    j.Apply(j.Member(j.Var('provider'), 'Function'), [j.String(name), j.Array([j.Var(parameter.name) for parameter in parameters])]),
  );

local functionBlocks(functions) = if std.length(std.objectFields(functions)) == 0 then [] else [
  j.Field(j.String('Function'), j.Object([
    functionBlock(name, functions[name])
    for name in std.objectFields(functions)
  ]).closeFodder(j.Fodder.LineEnd())),
];

local providerRequirements(source, version) = j.FieldLocal('requirements', j.Object([
  j.Field(j.String('source'), j.String(source)),
  j.Field(j.String('version'), j.String(version)),
]).closeFodder(j.Fodder.LineEnd()));

local providerConfiguration(provider) =
  local attributes = std.get(provider.block, 'attributes', {});
  j.FieldFunction(
    'withConfiguration',
    [j.Parameter('alias'), j.Parameter('block')],
    j.Apply(j.Var('provider'), [
      j.Var('block'),
      j.Object(std.flattenArrays([[
        j.Field('alias', j.Var('alias')),
      ]] + [
        local attribute = attributes[attributeName];
        if std.get(attribute, 'computed', false) then [] else
          [
            j.Field(
              j.String(attributeName),
              j.Apply(j.Member(j.Var('build'), 'template'), [
                if std.get(attribute, 'required', false)
                then j.Index(j.Var('block'), j.String(attributeName))
                else j.Std.get(j.Var('block'), j.String(attributeName)).default(j.Null),
              ])
            ),
          ]
        for attributeName in std.objectFields(attributes)
      ])).closeFodder(j.Fodder.LineEnd()),
    ])
  );

local terraformProvider(provider) =
  local providerSchema = provider.schema.provider_schemas[std.objectFields(provider.schema.provider_schemas)[0]];
  j.Locals(
    [
      build,
      providerTemplate,
      j.LocalFunctionBind('provider', [j.Parameter('rawConfiguration'), j.Parameter('configuration')], j.Object(
        [
          providerRequirements(provider.source, provider.version),
          j.FieldLocal('provider', j.Apply(j.Var('providerTemplate'), [j.String(provider.name), j.Var('requirements'), j.Var('rawConfiguration'), j.Var('configuration')])),
        ]
        + resourceBlocks(provider.name, 'resource', std.get(providerSchema, 'resource_schemas', {}))
        + resourceBlocks(provider.name, 'data', std.get(providerSchema, 'data_source_schemas', {}))
        + functionBlocks(std.get(providerSchema, 'functions', {})),
      ).closeFodder(j.Fodder.LineEnd())),
      j.LocalBind('providerWithConfiguration', j.Add(j.Apply(j.Var('provider'), [j.Null, j.Null]), j.Object([
        providerConfiguration(providerSchema.provider),
      ]).closeFodder(j.Fodder.LineEnd()))),
    ],
    j.Var('providerWithConfiguration')
  ).fodder(j.Fodder.LineEnd());

local pkg(provider) = j.Local(
  j.LocalBind('p', j.Import('pkg/main.libsonnet')),
  j.Apply(j.Member(j.Var('p'), 'pkg'), [
    j.Object([
      j.Field('repo', j.String('git@github.com:marcbran/jsonnet.git')),
      j.Field('branch', j.String('terraform-provider/%s' % std.objectFields(provider.schema.provider_schemas)[0])),
      j.Field('path', j.String('terraform-provider-%s' % provider.name)),
      j.Field('target', j.String(provider.name)),
    ]).closeFodder(j.Fodder.LineEnd()),
    j.String('Terraform provider %s' % provider.name),
  ]).fodder(j.Fodder.LineEnd()),
);

local terraformProviderDir(provider) = {
  'main.libsonnet': j.manifestJsonnet(terraformProvider(provider)),
  'pkg.libsonnet': j.manifestJsonnet(pkg(provider)),
};

terraformProviderDir
