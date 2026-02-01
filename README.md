# Pillar – AI Chatbot for TempleOS (God Words)

**Pillar** is a HolyC chatbot for **TempleOS** tied into **God Words**—the entire Bible (KJV) built into the Temple. You can ask for specific verses, random passages, or chat about the Temple and HolyC.

## Features

- **God Words (entire Bible)**  
  - **verse &lt;ref&gt;** – e.g. `verse John 3:16`, `verse Genesis 1:1` → prints that verse (and a few lines).  
  - **passage** / **god words** – random passage from the full Bible.  
  - **random verse** / **random passage** – same, shorter random passage.  
  - **bible** – random passage or a hint to use `verse` / `passage`.

- **Chat**  
  Greetings, TempleOS, HolyC, God/Terry, Pillar, help, thanks. Case-insensitive keyword matching.

- **Exit**  
  **bye**, **quit**, or **exit**.

## How to run on TempleOS

1. Ensure the **God** module and **God Words** (Bible) are present under `::/Adam/God/` (e.g. `GodWords.DD` and `GodBible.HC`).
2. Copy `Pillar.HC` into your TempleOS tree (e.g. `Home:`).
3. Run from shell: **`Pillar.HC`**  
   Or open `Pillar.HC` in the editor and run/execute it.

Pillar includes `::/Adam/God/GodBible` and calls `BibleInit` at startup so verse and passage lookups use the same Bible data as the rest of the Temple.

## Example

```
*** Pillar ***
AI chatbot for TempleOS, tied to God Words (entire Bible).
Say: verse John 3:16 | random verse | passage | god words | help | bye

You: verse John 3:16
Pillar:

John 3:16 For God so loved the world...

You: passage
Pillar: From the Bible:

[Psalms 23:1]
The LORD is my shepherd...

You: bye
Pillar: Peace be with you. Until we talk again.
```

## Requirements

- **TempleOS** with the **God** module (e.g. `::/Adam/God/GodBible` and `GodWords.DD`).
- If the Bible file lives elsewhere, define `BIBLE_FILENAME` before including GodBible (or edit the `#define` at the top of `Pillar.HC`).

## File

- **Pillar.HC** – HolyC source; includes GodBible, defines verse/passage commands and chat logic.
