import { neoApi } from './neoApi';

export const favoritesAPI = {
  // Получение всех избранных
  getFavorites() {
    return neoApi.get('/api/v1/favorites');
  },

  // Добавление в избранное
  addFavorite(mediaId: string) {
    return neoApi.post(`/api/v1/favorites/${mediaId}`);
  },

  // Удаление из избранного
  removeFavorite(mediaId: string) {
    return neoApi.delete(`/api/v1/favorites/${mediaId}`);
  }
};
