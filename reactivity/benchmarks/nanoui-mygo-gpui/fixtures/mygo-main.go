// luna-bench is a native, X11-observable interaction fixture, not a framework
// microbenchmark. It intentionally shows the row-count cost before the marker.
package main

import (
	"log"
	"os"
	"strconv"

	"github.com/egoist/mygo"
	"github.com/egoist/mygo/ui"
)

type bench struct {
	state ui.ListState
	count int
	mode string
	on bool
}

func (s *bench) view(c *ui.Context) {
	ui.Column(c).Fill().Padding(8).Gap(6).Children(func() {
		ui.Row(c).Height(48).Gap(8).Children(func() {
			color := ui.RGB(220, 20, 30)
			if s.on { color = ui.RGB(20, 190, 40) }
			ui.Box(c).Size(40, 40).Background(color)
			if ui.Button(c.Key("toggle"), "Toggle pixel marker").Width(240).Height(40).Font("DejaVu Sans").FontSize(16).Clicked() { s.on = !s.on }
			ui.Text(c, "marker").Height(24).Font("DejaVu Sans").FontSize(16).NoWrap()
		})
		if s.mode == "virtual" {
			ui.List(c, &s.state, s.count).Grow(1).Rows(func(row ui.ListRow) {
				ui.Text(row.Context, "row "+strconv.Itoa(row.Index)).Height(24).Font("DejaVu Sans").FontSize(16).NoWrap()
			})
		} else {
			ui.Column(c).Grow(1).Children(func() {
				for i := 0; i < s.count; i++ {
					ui.Box(c).Width(784).Height(24).Children(func() {
						ui.Text(c, "row "+strconv.Itoa(i)).Font("DejaVu Sans").FontSize(16).NoWrap()
					})
				}
			})
		}
	})
}

func main() {
	count, err := strconv.Atoi(os.Getenv("LUNA_ROWS")); if err != nil || count < 0 { count = 0 }
	mode := os.Getenv("LUNA_MODE"); if mode != "virtual" { mode = "eager" }
	s := &bench{count: count, mode: mode}
	mygo.App.WhenReady(func() {
		mygo.NewWindow(mygo.WindowOptions{Title: "Luna Benchmark", Width: 800, Height: 600, Content: ui.View(s.view)})
	})
	if err := mygo.App.Run(); err != nil { log.Fatal(err) }
}
