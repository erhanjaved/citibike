from pathlib import Path
import os
import pandas as pd
import gdown


def find_repo_root(start: Path) -> Path:
    for p in [start, *start.parents]:
        if (p / "README.md").exists() or (p / ".git").exists():
            return p
    raise RuntimeError("Repo root not found. Run from inside the repo.")


def main():
    # Locate repo root
    root = find_repo_root(Path.cwd())

    # Create data/raw at repo root
    data_dir = root / "data"
    raw_dir = data_dir / "raw"
    raw_dir.mkdir(parents=True, exist_ok=True)

    folder_url = "https://drive.google.com/drive/folders/1NhBgnlArKS2kISV44Cl-JOexjGWTcllE"

    # Download everything into data/raw
    gdown.download_folder(
        folder_url,
        output=str(raw_dir),
        quiet=False,
        use_cookies=False
    )

    # If gdown creates a nested folder, adjust here
    source_dir = raw_dir / "raw_data" if (raw_dir / "raw_data").exists() else raw_dir

    csv_files = [
        source_dir / f
        for f in os.listdir(source_dir)
        if f.startswith("202409-citibike-tripdata") and f.endswith(".csv")
    ]

    if not csv_files:
        raise FileNotFoundError(f"No matching CSVs found in {source_dir}")

    df = pd.concat([pd.read_csv(f) for f in csv_files], ignore_index=True)

    # Save combined file into data/raw
    out_path = raw_dir / "202409_citibike_tripdata_combined.csv"
    df.to_csv(out_path, index=False)

    print("Combined shape:", df.shape)
    print("Saved to:", out_path)


if __name__ == "__main__":
    main()