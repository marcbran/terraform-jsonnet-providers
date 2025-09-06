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

	err = jpoet.NewEval().
		FileImport([]string{dir}).
		FSImport(lib).
		FSImport(imports.Fs).
		Plugin(jsonnet.Plugin()).
		TLACode("providers", string(b)).
		FileInput("./lib/index.libsonnet").
		Serialize(false).
		DirectoryOutput(dir).
		Eval()
	if err != nil {
		return err
	}

	return nil
}
