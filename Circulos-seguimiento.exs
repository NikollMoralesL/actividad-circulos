defmodule Circulos do
  @margen 50


  def generar(archivo_salida, cantidad, reduccion, radio \\ nil) do
    radio = radio || cantidad * reduccion
    lienzo = 2 * radio + @margen
    centro = div(lienzo, 2)

    circulos = dibujar_circulos(centro, centro, radio, cantidad, reduccion)

    svg = """
    <svg xmlns="http://www.w3.org/2000/svg"
    width="#{lienzo}" height="#{lienzo}"
    viewBox="0 0 #{lienzo} #{lienzo}">
    <rect width="100%" height="100%" fill="white"/>
    #{circulos}
    </svg>
    """

    File.write!(archivo_salida, svg)
    IO.puts("Imagen creada: #{archivo_salida}")
  end

  # Caso base 1: ya no faltan círculos por dibujar.
  defp dibujar_circulos(_cx, _cy, _radio, 0, _reduccion), do: ""

  # Caso base 2: el radio ya no es positivo, no se puede dibujar más.
  defp dibujar_circulos(_cx, _cy, radio, _faltan, _reduccion) when radio <= 0, do: ""

  # Caso recursivo: se dibuja el círculo actual y se llama de nuevo
  # con el radio reducido y un círculo menos por dibujar.
  defp dibujar_circulos(cx, cy, radio, faltan, reduccion) do
    circulo = dibujar_circulo(cx, cy, radio)
    nuevo_radio = radio - reduccion

    circulo <> dibujar_circulos(cx, cy, nuevo_radio, faltan - 1, reduccion)
  end

  # Dibuja un círculo con un color aleatorio.
  defp dibujar_circulo(cx, cy, radio) do
    color = color_aleatorio()

    """
    <circle cx="#{cx}" cy="#{cy}" r="#{radio}"
    fill="none" stroke="#{color}" stroke-width="2"/>
    """
  end

  # Genera un color aleatorio en formato rgb(r, g, b).
  defp color_aleatorio() do
    rojo = :rand.uniform(256)
    verde = :rand.uniform(256)
    azul = :rand.uniform(256)

    "rgb(#{rojo}, #{verde}, #{azul})"
  end
end

Circulos.generar("circulos.svg", 20, 10)
