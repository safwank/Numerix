defmodule Numerix.DistanceSpec do
  use ESpec, async: true

  describe "minkowski/2" do
    before do: {:ok, distance: &(described_module.minkowski/2)}

    it_behaves_like(ADistanceFunction)

    context "when the vectors are unequal and using the default lambda" do
      let :vector1, do: [1, 3, 5, 6, 8, 9]
      let :vector2, do: [2, 5, 6, 6, 7, 7]

      subject do: described_module.minkowski(vector1, vector2)

      it do: should eq 2.6684016487219897
    end

    context "when the vectors are unequal and lambda is 5" do
      let :vector1, do: [1, 3, 5, 6, 8, 9]
      let :vector2, do: [2, 5, 6, 6, 7, 7]
      let :lambda, do: 5

      subject do: described_module.minkowski(vector1, vector2, lambda)

      it do: should eq 2.3185419629968713
    end
  end

  describe "euclidean/2" do
    subject do: described_module.euclidean(vector1, vector2)

    before do: {:ok, distance: &(described_module.euclidean/2)}

    it_behaves_like(ADistanceFunction)

    context "when the vectors are unequal with example #1" do
      let :vector1, do: [1, 3, 5, 6, 8, 9, 6, 4, 3, 2]
      let :vector2, do: [2, 5, 6, 6, 7, 7, 5, 3, 1, 1]

      it do: should eq 4.2426406871196605
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
