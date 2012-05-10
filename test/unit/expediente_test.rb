# Encoding: UTF-8
require 'test_helper'

class ExpedienteTest < ActiveSupport::TestCase
  test "la ley sobre el puente y sus relaciones" do
    @expediente = expedientes(:puente)
    assert_equal "Ley", @expediente.tipo, "el tipo no es leido correctamente"
    assert_equal temas(:edificaciones), @expediente.tema, "tema no devuelve una relacion"
    assert_equal "Mesa de entrada", @expediente.tipoentr, "la entrada no se muestra correctamente"
    assert_equal "De prorroga", @expediente.tipoperiod, "el periodo no se muestra correctamente"
    assert_equal 6, @expediente.estados.count, "No tiene los estados"
    assert_equal asuntos(:puente), @expediente.asuntos.first, "El asunto no está asociado"
    assert_equal finals(:puente), @expediente.finals.first, "El final no esta asociado"
  end
  
end

