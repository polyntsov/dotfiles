import os
import time
import random
import sys
import argparse

# Configuration
# WIDTH = 80 # You can set a fixed width or use the line below for auto-detection
WIDTH = os.get_terminal_size().columns
HEIGHT = 22
SNOW_DENSITY = int(WIDTH * 0.7)  # Scales snow with screen size
WIND_STRENGTH = 1

# --- LOGO LOADING ---
try:
    logo_path = os.path.join(os.path.dirname(__file__), "nix_logo.txt")
    with open(logo_path, "r", encoding="utf-8") as f:
        NIXOS_LOGO = f.read().splitlines()
except FileNotFoundError:
    NIXOS_LOGO = ["Logo file not found!"]

# Assets
MOON = [r"  .---.  ", r" /  .-'  ", r"|  |     ", r" \  '-.  ", r"  '---'  "]
MOUNTAIN_ASSET = [
    r"      /\            /\            /\      ",
    r" /\  /  \  /\      /  \  /\      /  \  /\ ",
    r"/  \/    \/  \    /    \/  \    /    \/  \\",
]
TREE = [r"  ^  ", r" / \ ", r"/   \\", r" ||| "]


class Snowflake:
    def __init__(self):
        self.x = random.randint(0, WIDTH - 1)
        self.y = random.randint(0, HEIGHT - 1)
        self.char = random.choice(["*", ".", "·"])

    def update(self):
        self.y = (self.y + 1) % HEIGHT
        self.x = (self.x + WIND_STRENGTH) % WIDTH


def build_scene():
    canvas = [[" " for _ in range(WIDTH)] for _ in range(HEIGHT)]

    # 1. Moon (Pinned to the Top-Right Corner)
    moon_x_start = WIDTH - 12
    for r, line in enumerate(MOON):
        for c, char in enumerate(line):
            target_c = c + moon_x_start
            if char != " " and 0 <= target_c < WIDTH:
                canvas[r + 1][target_c] = char

    # 2. Infinite Tiled Mountains
    # We repeat the mountain asset across the width
    asset_w = len(MOUNTAIN_ASSET[0])
    for m_offset in range(
        -10, WIDTH, asset_w - 5
    ):  # -5 to overlap slightly for "jaggedness"
        for r, line in enumerate(MOUNTAIN_ASSET):
            for c, char in enumerate(line):
                target_c = c + m_offset
                if char != " " and 0 <= target_c < WIDTH:
                    # Only place if space is empty to allow overlapping peaks
                    if canvas[r + 12][target_c] == " ":
                        canvas[r + 12][target_c] = char

    # 3. Infinite Forest
    # Place a tree every few characters across the whole width
    current_x = 2
    while current_x < WIDTH - 5:
        offset_y = random.choice([0, 1])
        for r, line in enumerate(TREE):
            for c, char in enumerate(line):
                if char != " ":
                    target_y = r + 17 - offset_y
                    target_c = c + current_x
                    if target_y < HEIGHT and target_c < WIDTH:
                        canvas[target_y][target_c] = char
        current_x += random.randint(7, 12)  # Random spacing for natural look

    # 4. The Cabin (Always near the left-center area)
    cabin = [r"  __  ", r" /  \_", r"/____\\", r"|_[]_|"]
    cabin_x = 25
    for r, line in enumerate(cabin):
        for c, char in enumerate(line):
            target_c = c + cabin_x
            if char != " " and 0 <= target_c < WIDTH:
                canvas[r + 17][target_c] = char

    return canvas


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--transition", type=float, default=2.0, help="Seconds before transition"
    )
    args = parser.parse_args()

    snowflakes = [Snowflake() for _ in range(SNOW_DENSITY)]
    static_scene = build_scene()
    start_time = time.time()

    sys.stdout.write("\033[?25l")  # Hide cursor
    sys.stdout.write("\n" * HEIGHT)
    sys.stdout.write(f"\033[{HEIGHT}F")
    sys.stdout.flush()

    try:
        # 1. Animation Loop
        while time.time() - start_time < args.transition:
            frame = [row[:] for row in static_scene]
            for s in snowflakes:
                s.update()
                if frame[s.y][s.x] == " ":
                    frame[s.y][s.x] = s.char

            sys.stdout.write("\n".join("".join(r) for r in frame))
            sys.stdout.flush()
            time.sleep(0.1)
            sys.stdout.write(f"\033[{HEIGHT - 1}F")

        # 2. Transition Logic (Overwrite left-to-right into Nix Logo)
        logo_canvas = [[" " for _ in range(WIDTH)] for _ in range(HEIGHT)]
        start_c = 0
        start_r = max(0, (HEIGHT - len(NIXOS_LOGO)) // 2)

        for r, line in enumerate(NIXOS_LOGO):
            if r + start_r >= HEIGHT:
                break
            for c, char in enumerate(line):
                if c + start_c < WIDTH:
                    logo_canvas[r + start_r][c + start_c] = char

        indices = [(r, c) for r in range(HEIGHT) for c in range(WIDTH)]
        random.shuffle(indices)

        steps = 18
        chunk_size = len(indices) // steps
        current_frame = [row[:] for row in static_scene]

        for i in range(steps):
            for r, c in indices[i * chunk_size : (i + 1) * chunk_size]:
                current_frame[r][c] = logo_canvas[r][c]

            sys.stdout.write("\n".join("".join(r) for r in current_frame))
            sys.stdout.flush()
            time.sleep(0.04)
            sys.stdout.write(f"\033[{HEIGHT - 1}F")

        sys.stdout.write("\033[?25h")
        sys.stdout.flush()

    except KeyboardInterrupt:
        sys.stdout.write("\033[?25h\n")
        sys.stdout.flush()
        sys.exit(0)


if __name__ == "__main__":
    main()
