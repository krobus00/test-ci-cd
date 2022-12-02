package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "test 10 sep aaaaa")
	})
	e.GET("/ip", func(c echo.Context) error {
		return c.JSON(http.StatusOK, echo.Map{
			"realIP":     c.RealIP(),
			"remoteAddr": c.Request().RemoteAddr,
		})
	})
	e.Logger.Fatal(e.Start(":1323"))
}
