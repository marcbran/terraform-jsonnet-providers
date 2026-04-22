package internal

import (
	"context"
	"encoding/json"

	"github.com/marcbran/jpoet/pkg/jpoet"
	"github.com/marcbran/jsonnet-plugin-jsonnet/jsonnet"
	"github.com/marcbran/terraform-jsonnet-providers/internal/lib/imports"
)

func Gen(context context.Context, dir string) error {
	provider, err := pullProvider(dir)
	if err != nil {
		return err
	}

	b, err := json.Marshal(provider)
	if err != nil {
		return err
	}

	err = jpoet.Eval(
		jpoet.FileImport([]string{}),
		jpoet.FSImport(lib),
		jpoet.FSImport(imports.Fs),
		jpoet.WithPlugin(jsonnet.Plugin()),
		jpoet.TLACode("provider", string(b)),
		jpoet.FileInput("./lib/gen.libsonnet"),
		jpoet.Serialize(false),
		jpoet.DirectoryOutput(dir),
	)
	if err != nil {
		return err
	}

	return nil
}
