defmodule ExMonTest do
  use ExUnit.Case

  import ExUnit.CaptureIO

  alias ExMon.Player

  describe "create_player/4" do
    test "returns a player" do
      expected_response = %Player{
        life: 100,
        name: "Gabriel",
        moves: %{move_avg: :soco, move_heal: :cura, move_rnd: :chute}
      }

      assert ExMon.create_player("Gabriel", :chute, :soco, :cura) == expected_response
    end
  end

  describe "start_game/1" do
    test "when the game is started" do
      player = Player.build("Gabriel", :chute, :soco, :cura)

      messages =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert messages =~ "The game is started"
    end
  end

  describe "make_move/1" do
    setup do
      player = Player.build("Gabriel", :chute, :soco, :cura)

      capture_io(fn ->
        ExMon.start_game(player)
      end)

      {:ok, player: player}
    end

    test "when the is valid, do the move and the computer makes a move" do
      messages =
        capture_io(fn ->
          assert ExMon.make_move(:chute)
        end)

      assert messages =~ "The player attacked the computer"
      assert messages =~ "It's computer turn"
      assert messages =~ "status: :continue"
    end

    test "when the is invalid, returns an error message" do
      messages =
        capture_io(fn ->
          assert ExMon.make_move(:wrong)
        end)

      assert messages =~ "Invalid move: wrong"
    end
  end
end
