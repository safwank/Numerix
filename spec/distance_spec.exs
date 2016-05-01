defmodule Numerix.DistanceSpec do
  use ESpec, async: true

  describe "euclidean/2" do
    subject do: described_module.euclidean(vector1, vector2)

    before do: {:ok, distance: &(described_module.euclidean/2)}

    it_behaves_like(ADistanceFunction)

    context "when the vectors are unequal with example #1" do
      let :vector1, do: [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      let :vector2, do: [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      it do: should eq 4.242640687119285
    end
  end

  describe "manhattan/2" do
    subject do: described_module.manhattan(vector1, vector2)

    before do: {:ok, distance: &(described_module.manhattan/2)}

    it_behaves_like(ADistanceFunction)

    context "when the vectors are unequal with example #1" do
      let :vector1, do: [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      let :vector2, do: [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      it do: should eq 12
    end
  end
end
