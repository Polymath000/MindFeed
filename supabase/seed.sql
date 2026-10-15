INSERT INTO public.categories (id, name, slug, description)
VALUES
  ('2fee2891-a998-449b-9068-57e60eef42c2', 'Art & Design', 'art-design', 'Typography, architecture, visual interfaces, and aesthetics'),
  ('46f0efdc-2a8f-4c30-ac40-0cc88cfc3b4e', 'Books & Literature', 'books-literature', 'Literary critique, profound essays, reading lists, and author profiles'),
  ('e3af1cd2-b787-4037-8770-cc4fa4534870', 'Business & Entrepreneurship', 'business-entrepreneurship', 'Startups, corporate strategy, executive leadership, and business models'),
  ('51ced5b2-6e60-4def-9825-a2456f03a3d6', 'Education & Learning', 'education-learning', 'Pedagogy, cognitive retention, learning systems, and academic insight'),
  ('173a58b4-776c-40cd-a50a-6ce3492e6806', 'Entertainment & Movies', 'entertainment-movies', 'Cinema, performing arts, storytelling, and cultural entertainment'),
  ('6891a1ec-febf-4ac0-b0ae-536f6c7bc788', 'Environment & Sustainability', 'environment-sustainability', 'Renewable energy, ecology, and climate systems'),
  ('d58c248c-d339-400b-8fb6-e3b2012c6b08', 'Finance & Investing', 'finance-investing', 'Global supply chains, finance, and trade compacts'),
  ('ddf8be4e-2152-48a1-b3b6-fcf616fe2752', 'Food & Cooking', 'food-cooking', 'Culinary arts, food science, gastronomical explorations, and recipes'),
  ('67821015-ab5a-4711-ae6c-ef1026dff7cc', 'Health & Wellness', 'health-wellness', 'Medicine, neuroscience, biology, and wellness research'),
  ('602252f8-f441-4cf3-baf8-740c41e377fc', 'History', 'history', 'Historical narratives, ancient civilizations, and archival records'),
  ('1cc34be4-f18b-4295-a942-5965f28fc523', 'Lifestyle', 'lifestyle', 'Modern living, design for life, balance, and contemporary culture'),
  ('361de395-39e9-47aa-a74a-44eea1f1da77', 'News & Current Events', 'news-current-events', 'Global reports, investigative journalism, and timely reporting'),
  ('a8f90dc9-0e23-491e-b61c-c37e884f92c1', 'Personal Development', 'personal-development', 'Growth mindset, productivity habits, focus, and self-improvement'),
  ('328011a2-aeaa-4254-9480-cbf2b8ce72ff', 'Politics', 'politics', 'Digital governance, regulation, and public institutions'),
  ('6853d951-f329-45d1-80ca-3686f422e7f6', 'Programming & Software Development', 'programming-software-dev', 'Code craftsmanship, system design, architectural patterns, and dev practice'),
  ('cf1e26eb-372a-45fe-a932-c35a3d3ca5fb', 'Psychology', 'psychology', 'Behavioral economics, neuroscience, cognition, and emotional resilience'),
  ('7224eaf7-068c-427e-a06a-bd336e9a2fd6', 'Science', 'science', 'Physics, chemistry, biology, and scientific discoveries'),
  ('45b6e30d-0f0f-4613-85dd-bf799bac2027', 'Sports', 'sports', 'Global tournaments, athletics, and competitions'),
  ('7370e59d-b08f-43ff-96aa-12982c7a85e0', 'Technology', 'technology', 'Software, devices, hardware, and engineering breakthroughs'),
  ('fb6eb820-f29f-4a80-ae3e-e1cc5d04f5ed', 'Travel & Culture', 'travel-culture', 'Global explorations, cultural anthropology, and worldwide perspectives')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug,
  description = EXCLUDED.description;

INSERT INTO public.fixed_tags (id, name, slug)
VALUES
  ('99fed155-324f-4d17-a577-4a77e51a97bc', 'AI & Machine Learning', 'ai-machine-learning'),
  ('dd2d3d43-4cd1-4638-8efe-5836a8b56955', 'Deep Work', 'deep-work'),
  ('79d0d478-7e12-411e-b507-5d4fd7b954e4', 'Future of Tech', 'future-of-tech'),
  ('998ff953-166b-49ff-a4e4-3cd9171cbd61', 'Leadership', 'leadership'),
  ('7edf0376-4aa3-483a-b3f0-ef575bd63498', 'Mental Health', 'mental-health'),
  ('6478dc7b-543a-459c-a453-baa08c61c843', 'Mobile Dev', 'mobile-dev'),
  ('1a246642-fc75-495d-a868-b5fae2345223', 'Product Strategy', 'product-strategy'),
  ('f3c283ac-03a5-42ce-8dc4-566111da78cb', 'Psychology', 'psychology'),
  ('c115a0d9-114f-4de5-8c3e-7ed4b62aad22', 'Software Architecture', 'software-architecture'),
  ('9a779c8e-0938-4614-a9a7-7022019b57d6', 'Startups', 'startups'),
  ('08da09e0-6834-44fa-9884-c26419589ff7', 'UI/UX Design', 'ui-ux-design'),
  ('cd854cf8-9079-489b-bc94-744de2655516', 'Writing & Creativity', 'writing-creativity')
ON CONFLICT (id) DO UPDATE SET
  name = EXCLUDED.name,
  slug = EXCLUDED.slug;
