defmodule LangLangTest do
  use ExUnit.Case

  alias :langlang_lexer, as: L
  alias :langlang_parser, as: P

  test "integers" do
    {:ok, tokens, _} = L.string('315')

    assert {:ok, {:integer, 1, 315}} == tokens |> P.parse
  end

  test "floats" do
    {:ok, tokens, _} = L.string('315.513')

    assert {:ok, {:float, 1, 315.513}} == tokens |> P.parse
  end

  test "addition with two numbers" do
    {:ok, tokens, _} = L.string('111+222.33')

    expected = {:ok, {:binary_op, 1, :+,
                      {:integer, 1, 111 }, {:float, 1, 222.33 }}}

    assert expected == tokens |> P.parse
  end

  test "addition with three numbers" do
    {:ok, tokens, _} = L.string('1+2+3')

    expected = {:ok, {:binary_op, 1, :+,
                      {:binary_op, 1, :+, {:integer, 1, 1}, {:integer, 1, 2}},
                      {:integer, 1, 3}}}

    assert expected == tokens |> P.parse
  end

  test "whitespace" do
    {:ok, tokens, _} = L.string('  111  +  222.33  ')

    expected = {:ok, {:binary_op, 1, :+,
                      {:integer, 1, 111 }, {:float, 1, 222.33 }}}

    assert expected == tokens |> P.parse
  end

  test "subtraction with two numbers" do
    {:ok, tokens, _} = L.string('111-222.33')

    expected = {:ok, {:binary_op, 1, :-,
                      {:integer, 1, 111 }, {:float, 1, 222.33 }}}

    assert expected == tokens |> P.parse
  end

  test "addition and subtraction" do
    {:ok, tokens, _} = L.string('1+2-3')

    expected = {:ok, {:binary_op, 1, :-,
                      {:binary_op, 1, :+, {:integer, 1, 1}, {:integer, 1, 2}},
                      {:integer, 1, 3}}}

    assert expected == tokens |> P.parse
  end

end
