package main

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.GET("/", func(c echo.Context) error {
		return c.String(http.StatusOK, "krobot ddd")
	})
	e.GET("/health", func(c echo.Context) error {
		return c.String(http.StatusOK, "OK")
	})
	e.GET("/readiness", func(c echo.Context) error {
		return c.String(http.StatusOK, "service ready")
	})
	e.GET("/ip", func(c echo.Context) error {
		return c.JSON(http.StatusOK, echo.Map{
			"realIP":     c.RealIP(),
			"remoteAddr": c.Request().RemoteAddr,
		})
	})
	e.Logger.Fatal(e.Start(":8000"))
}
