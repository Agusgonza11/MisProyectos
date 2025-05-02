import { faker as fakerInstance } from '@faker-js/faker';

fakerInstance.seed(123);

export const faker = fakerInstance;
