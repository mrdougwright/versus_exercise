defmodule VersusTest do
  use ExUnit.Case
  doctest Versus

  describe "conceal/1" do
    test "replaces chars with asterisks" do
      assert Versus.conceal("MagicSnowman32") == "******"
    end

    test "replaces first part for emails" do
      assert Versus.conceal("elsa@arendelle.com") == "******@arendelle.com"
    end
  end

  describe "scrub/1" do
    test "scrubs personal data from json" do
      input = %{
        id: 123,
        name: "Elsa",
        username: "xXfrozen_princessXx",
        email: "elsa@arendelle.com",
        age: 21,
        power: "ice ray",
        friends: [
          %{
            id: 234,
            username: "MagicSnowman32"
          },
          %{
            id: 456,
            username: "call_me_anna"
          }
        ]
      }

      output = %{
        id: 123,
        name: "******",
        username: "******",
        email: "******@arendelle.com",
        age: 21,
        power: "ice ray",
        friends: [
          %{
            id: 234,
            username: "******"
          },
          %{
            id: 456,
            username: "******"
          }
        ]
      }

      assert Versus.scrub(input) == output
    end

    test "scrubs hard on nested data" do
      input = %{
        id: 123,
        name: "bob",
        shows: [
          %{
            name: "bob burger",
            network: "fox",
            agents: [%{email: "bob@uta.com", username: "test"}]
          },
          %{name: "archer", network: "fx", agents: [%{email: "sue@wm.com", username: "test"}]}
        ]
      }

      output = %{
        id: 123,
        name: "******",
        shows: [
          %{
            agents: [%{username: "******", email: "******@uta.com"}],
            name: "******",
            network: "fox"
          },
          %{
            agents: [%{username: "******", email: "******@wm.com"}],
            name: "******",
            network: "fx"
          }
        ]
      }

      assert Versus.scrub(input) == output
    end
  end
end
