package cmd

import (
	"fmt"
	"github.com/spf13/cobra"
	"os"
)

var Cmd = &cobra.Command{
	Use:   "terraform-jsonnet-providers",
	Short: "",
	Long:  ``,

	DisableAutoGenTag: true,
}

func init() {
	Cmd.AddCommand(indexCmd)
	Cmd.AddCommand(genCmd)
}

func Execute() {
	if err := Cmd.Execute(); err != nil {
		fmt.Fprintln(os.Stderr, err)
		os.Exit(2)
	}
}
