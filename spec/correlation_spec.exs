defmodule Numerix.CorrelationSpec do
  use ESpec, async: true

  describe "pearson/2" do

    subject do: described_module.pearson(vector1, vector2)

    context "when the first vector is empty" do
      let :vector1, do: []
      let :vector2, do: [1, 2, 3]

      it do: should eq :error
    end

    context "when the second vector is empty" do
      let :vector1, do: [1, 2, 3]
      let :vector2, do: []

      it do: should eq :error
    end

    context "when the vectors are equal" do
      let :vector1, do: [1, 2, 3]
      let :vector2, do: [1, 2, 3]

      it do: should eq 1.0
    end

    context "when the vectors are unequal" do
      let :vector1, do: DataHelper.read("Lew") |> Enum.take(200)
      let :vector2, do: DataHelper.read("Lottery") |> Enum.take(200)

      it do: should eq -0.02947086158072648
    end

  end

end
