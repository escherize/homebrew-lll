# Homebrew formula template for lll. The release workflow
# (.github/workflows/release.yml) renders this on every v* tag: it replaces
# the __MARKERS__ below with the tag version and the sha256 of each release
# binary, then pushes the result to the tap repo (default
# escherize/homebrew-lll, override with TAP_REPO).
#
# Binary names here must match the artifacts the release workflow attaches:
# dist/lll-darwin-arm64, dist/lll-linux-amd64, dist/lll-linux-arm64.
#
# Until the tap repo exists and a TAP_TOKEN secret is set, the workflow skips
# the tap push and this template is the source of truth to copy by hand.

class Lll < Formula
  desc "Shared record for people and coding agents"
  homepage "https://github.com/escherize/lll"
  version "1.8.0"

  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-darwin-arm64"
      sha256 "6137072fe1a270130b8b69d8eb6f2bd06c7e9ddaf6aa99bcac3a6e54b621963a"
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-amd64"
      sha256 "0e14117d2b9a45d4b839915ce567439773e1062264b3a68238823593287c519f"
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/escherize/lll/releases/download/v#{version}/lll-linux-arm64"
      sha256 "c84b33ed2f05bd89129cc05e8b32cdd5aff44e82f9b0fe66f9a24ec2b40dbe47"
    end
  end

  def install
    # Release assets are bare binaries named per platform; the staged file
    # keeps that name, so install renames it to lll. (Verified by a real
    # `brew install escherize/lll/lll` against the v0.2.0 tap.)
    if OS.mac?
      bin.install "lll-darwin-arm64" => "lll"
    elsif OS.linux? && Hardware::CPU.intel?
      bin.install "lll-linux-amd64" => "lll"
    else
      bin.install "lll-linux-arm64" => "lll"
    end
  end

  test do
    assert_match "lll #{version}", shell_output("#{bin}/lll --version")
  end
end
