defmodule ADistanceFunction do
  use ESpec, shared: true, async: true

  subject shared.distance.(vector1, vector2)

  context "when both vectors are empty" do
    let :vector1, do: []
    let :vector2, do: []

    it do: should eq :error
  end

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

    it do: should eq 0
  end
end
