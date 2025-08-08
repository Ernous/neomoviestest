import { Metadata } from 'next';
import { MoviesSection } from '@/components/MoviesSection';
import { Trending } from '@/components/Trending';

export const metadata: Metadata = {
  title: 'Neo Movies',
  description: 'Смотрите фильмы онлайн',
};

export default function HomePage() {
  return (
    <main className="min-h-screen bg-background px-4 py-6 text-foreground md:px-6 lg:px-8">
      <div className="container mx-auto">
        <h1 className="text-2xl font-semibold">Neo Movies</h1>
      </div>
    </main>
  );
}
