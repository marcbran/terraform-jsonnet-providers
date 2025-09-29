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

	err = jpoet.NewEval().
		FileImport([]string{}).
		FSImport(lib).
		FSImport(imports.Fs).
		Plugin(jsonnet.Plugin()).
		TLACode("provider", string(b)).
		FileInput("./lib/gen.libsonnet").
		Serialize(false).
		DirectoryOutput(dir).
		Eval()
	if err != nil {
		return err
	}

	return nil
}
