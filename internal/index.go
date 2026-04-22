package internal

import (
	"context"
	"encoding/json"

	"github.com/marcbran/jpoet/pkg/jpoet"
	"github.com/marcbran/jsonnet-plugin-jsonnet/jsonnet"
	"github.com/marcbran/terraform-jsonnet-providers/internal/lib/imports"
)

func Index(ctx context.Context, dir string) error {
	providers, err := pullAllProviders(dir)
	if err != nil {
		return err
	}

	b, err := json.Marshal(providers)
	if err != nil {
		return err
	}

	err = jpoet.Eval(
		jpoet.FileImport([]string{dir}),
		jpoet.FSImport(lib),
		jpoet.FSImport(imports.Fs),
		jpoet.WithPlugin(jsonnet.Plugin()),
		jpoet.TLACode("providers", string(b)),
		jpoet.FileInput("./lib/index.libsonnet"),
		jpoet.Serialize(false),
		jpoet.DirectoryOutput(dir),
	)
	if err != nil {
		return err
	}

	return nil
}
