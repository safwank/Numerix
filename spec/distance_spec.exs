defmodule Numerix.DistanceSpec do
  use ESpec

  describe "euclidean/2" do

    subject do: described_module.euclidean(vector1, vector2)

    context "when the first vector is empty" do
      let :vector1, do: []
      let :vector2, do: [1, 2, 3]

      it do: should eq 0
    end

    context "when the second vector is empty" do
      let :vector1, do: [1, 2, 3]
      let :vector2, do: []

      it do: should eq 0
    end

    context "when the vectors are equal" do
      let :vector1, do: [1, 2, 3]
      let :vector2, do: [1, 2, 3]

      it do: should eq 0
    end

    context "when the vectors are unequal" do
      let :vector1, do: [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      let :vector2, do: [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      it do: should eq 4.242640687119285
    end

  end

end
