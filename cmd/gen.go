package cmd

import (
	"github.com/marcbran/terraform-jsonnet-providers/internal"
	"github.com/spf13/cobra"
)

var genCmd = &cobra.Command{
	Use:   "gen [flags] directory",
	Short: "Gens Jsonnet code for provider",
	Long:  ``,

	DisableAutoGenTag: true,
	RunE: func(cmd *cobra.Command, args []string) error {
		cmd.SilenceUsage = true
		cmd.SilenceErrors = true
		providerDir := "."
		if len(args) > 0 {
			providerDir = args[0]
		}
		err := internal.Gen(cmd.Context(), providerDir)
		if err != nil {
			return err
		}
		return nil
	},
}
