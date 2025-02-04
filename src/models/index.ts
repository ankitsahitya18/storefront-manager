import prisma from './prismaClient';

const xprisma = prisma.$extends({
	query: {},
});

export const Storefront = xprisma.storefront;
