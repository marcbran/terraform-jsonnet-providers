package cmd

import (
	"github.com/marcbran/terrason-providers/internal"
	"github.com/spf13/cobra"
)

var indexCmd = &cobra.Command{
	Use:   "index [flags] directory",
	Short: "Indexes repo",
	Long:  ``,

	DisableAutoGenTag: true,
	RunE: func(cmd *cobra.Command, args []string) error {
		cmd.SilenceUsage = true
		cmd.SilenceErrors = true
		dir := "."
		if len(args) > 0 {
			dir = args[0]
		}
		err := internal.Index(cmd.Context(), dir)
		if err != nil {
			return err
		}
		return nil
	},
}
