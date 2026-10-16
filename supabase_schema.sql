-- ==============================================================================
-- Run this script in the SQL Editor on your Supabase Dashboard
-- ==============================================================================

-- 1. Story Collections Table (story_collections)
CREATE TABLE IF NOT EXISTS public.story_collections (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    slug TEXT NOT NULL UNIQUE,
    title TEXT NOT NULL,
    subtitle TEXT,
    description TEXT,
    cover_image_url TEXT NOT NULL,
    badge TEXT,
    language TEXT NOT NULL DEFAULT 'en',
    version INT NOT NULL DEFAULT 1,
    order_index INT NOT NULL DEFAULT 0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

-- 2. Story Chapters Table (story_chapters)
CREATE TABLE IF NOT EXISTS public.story_chapters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    collection_id UUID NOT NULL REFERENCES public.story_collections(id) ON DELETE CASCADE,
    number INT NOT NULL,
    series_title TEXT NOT NULL,
    title TEXT NOT NULL,
    summary TEXT,
    paragraphs TEXT[] NOT NULL DEFAULT '{}',
    illustration_prompt TEXT,
    illustration_url TEXT NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT story_chapters_collection_number_key UNIQUE (collection_id, number)
);

-- 3. Performance Indexes (Query Optimization)
-- Speed up chapter lookups and ordered retrieval per collection
CREATE INDEX IF NOT EXISTS idx_story_chapters_collection_number
    ON public.story_chapters(collection_id, number ASC);

-- Speed up collection queries filtered by language and ordered by display index
CREATE INDEX IF NOT EXISTS idx_story_collections_lang_order
    ON public.story_collections(language, order_index ASC);

-- Speed up fetching all collections ordered by display index
CREATE INDEX IF NOT EXISTS idx_story_collections_order
    ON public.story_collections(order_index ASC);

-- 4. Security & Row Level Security (RLS) - Idempotent
ALTER TABLE public.story_collections ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.story_chapters ENABLE ROW LEVEL SECURITY;

-- Public read access policies (Anon & Authenticated)
DROP POLICY IF EXISTS "Allow public read access for story_collections" ON public.story_collections;
CREATE POLICY "Allow public read access for story_collections"
    ON public.story_collections FOR SELECT
    TO anon, authenticated
    USING (true);

DROP POLICY IF EXISTS "Allow public read access for story_chapters" ON public.story_chapters;
CREATE POLICY "Allow public read access for story_chapters"
    ON public.story_chapters FOR SELECT
    TO anon, authenticated
    USING (true);

-- Grant SELECT permissions to public roles
GRANT SELECT ON public.story_collections TO anon, authenticated;
GRANT SELECT ON public.story_chapters TO anon, authenticated;

-- ==============================================================================
-- 5. Initial Seed Data (1 Sample Collection & 1 Chapter)
-- ==============================================================================

DO $$
DECLARE
    v_collection_id UUID := 'e1f2a3b4-c5d6-4e7f-8a9b-0c1d2e3f4a5b';
BEGIN
    -- Sample Collection: The Clever Mouse Deer & Friends (English)
    INSERT INTO public.story_collections (
        id,
        slug,
        title,
        subtitle,
        description,
        cover_image_url,
        badge,
        language,
        version,
        order_index
    )
    VALUES (
        v_collection_id,
        'clever-mouse-deer',
        'The Clever Mouse Deer & Friends',
        'Enchanted Tales of Wisdom',
        'Join Kanca, the witty and gentle mouse deer, on heartwarming adventures through the lush tropical rainforest.',
        'https://images.unsplash.com/photo-1535268647677-300dbf3d78d1?auto=format&fit=crop&w=1200&q=80',
        'Classic Fable',
        'en',
        1,
        1
    )
    ON CONFLICT (slug) DO UPDATE SET
        title = EXCLUDED.title,
        subtitle = EXCLUDED.subtitle,
        description = EXCLUDED.description,
        cover_image_url = EXCLUDED.cover_image_url,
        badge = EXCLUDED.badge,
        language = EXCLUDED.language,
        version = EXCLUDED.version,
        order_index = EXCLUDED.order_index;

    -- Chapter 1: Crossing the River of Crocodiles
    INSERT INTO public.story_chapters (
        id,
        collection_id,
        number,
        series_title,
        title,
        summary,
        paragraphs,
        illustration_prompt,
        illustration_url
    )
    VALUES (
        'f2a3b4c5-d6e7-4f8a-9b0c-1d2e3f4a5b6c',
        v_collection_id,
        1,
        'The Clever Mouse Deer & Friends',
        'Crossing the River of Crocodiles',
        'Kanca needs to cross the wide river where sunbathing crocodiles guard the luscious fruit gardens.',
        ARRAY[
            'In a vibrant and peaceful forest, lived a tiny mouse deer named Kanca. Kanca was known throughout the valley not just for his nimble leaps, but for his bright mind and kind heart.',
            'One sunny afternoon, Kanca smelled sweet wild berries and juicy cucumbers across the wide, rushing river. But the river was deep, and a family of enormous crocodiles lay resting on the banks.',
            'Kanca greeted them with a polite smile: ''Greetings, mighty guardians of the river!'' The old crocodile leader surfaced with a rumble: ''Are you offering yourself as our lunch, little one?''',
            '''Not at all, dear uncle,'' Kanca replied calmly. ''The Great Forest King wishes to invite all crocodiles to tonight''s grand feast. Line up from this bank to the other so I may count you correctly!''',
            'Delighted by the news, the crocodiles promptly formed a neat bridge across the waters. Kanca leaped gracefully from back to back, counting cheerfully: ''One, two, three, four, five... and across!''',
            'Stepping safely onto the green meadow, Kanca waved with gratitude: ''Thank you, dear friends! Remember that gentle wisdom and good cheer can cross any river.'' With joy, he shared the fresh berries with his woodland friends.'
        ],
        'A clever mouse deer jumping across friendly crocodiles in a lush tropical river, warm storybook style',
        'https://images.unsplash.com/photo-1448375240586-882707db888b?auto=format&fit=crop&w=1200&q=80'
    )
    ON CONFLICT (collection_id, number) DO UPDATE SET
        title = EXCLUDED.title,
        series_title = EXCLUDED.series_title,
        summary = EXCLUDED.summary,
        paragraphs = EXCLUDED.paragraphs,
        illustration_prompt = EXCLUDED.illustration_prompt,
        illustration_url = EXCLUDED.illustration_url;
END $$;
