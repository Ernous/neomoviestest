import { Metadata } from 'next';
import { MoviesSection } from '@/components/MoviesSection';
import { Trending } from '@/components/Trending';

export const metadata: Metadata = {
  title: 'Neo Movies',
  description: 'Смотрите фильмы онлайн',
};

export default function HomePage() {
  return (
    <main>
      <Trending />
      <MoviesSection />
    </main>
  );
}
