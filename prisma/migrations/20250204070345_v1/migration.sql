-- CreateEnum
CREATE TYPE "BenefitSortCriteria" AS ENUM ('BenefitType', 'Category');

-- CreateEnum
CREATE TYPE "MembershipCriteria" AS ENUM ('NotRequired', 'Visible', 'NotVisible');

-- CreateEnum
CREATE TYPE "MerchantStatus" AS ENUM ('active', 'inActive');

-- CreateEnum
CREATE TYPE "RedeemType" AS ENUM ('CODE', 'PASS', 'QR', 'EMAIL', 'CALL');

-- CreateEnum
CREATE TYPE "BenefitType" AS ENUM ('model3d', 'video', 'audio', 'digitalbook', 'coupon', 'digitalcollectible', 'generic', 'streams', 'survey', 'sweepstakes');

-- CreateEnum
CREATE TYPE "DiscountType" AS ENUM ('flat', 'percentage', 'partner');

-- CreateEnum
CREATE TYPE "BenefitStatus" AS ENUM ('draft', 'inActive', 'active');

-- CreateEnum
CREATE TYPE "StorefrontTemplate" AS ENUM ('Default', 'Anime', 'Commercial');

-- CreateEnum
CREATE TYPE "StorefrontLoginOptions" AS ENUM ('Default', 'Email', 'SMS', 'EmailAndSMS');

-- CreateTable
CREATE TABLE "Storefront" (
    "id" SERIAL NOT NULL,
    "currentTierId" BIGINT,
    "title" VARCHAR(20) NOT NULL,
    "cnameUrl" VARCHAR(1500),
    "logoUrl" VARCHAR(1500) NOT NULL,
    "heroImageUrl" VARCHAR(1500),
    "heroHeadline" VARCHAR(1500),
    "heroDesc" VARCHAR(1500),
    "heroBenefitsHeadline" VARCHAR(1500),
    "heroBenefitsDescription" VARCHAR(1500),
    "marketingHeadline" VARCHAR(1500),
    "marketingDesc" VARCHAR(1500),
    "headerText" TEXT,
    "bodyText" TEXT,
    "pointsTableHeaderText" TEXT,
    "pointsTableBodyText" TEXT,
    "enableFooter" BOOLEAN NOT NULL DEFAULT false,
    "companyName" TEXT,
    "footerText" VARCHAR(1500),
    "websiteUrl" VARCHAR(1500),
    "twitterUrl" VARCHAR(1500),
    "discordUrl" VARCHAR(1500),
    "mediumUrl" VARCHAR(1500),
    "defaultChain" VARCHAR(100) DEFAULT 'mumbai',
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "createdBy" INTEGER,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "themeId" "StorefrontTemplate" NOT NULL DEFAULT 'Default',
    "loginMethod" "StorefrontLoginOptions" NOT NULL DEFAULT 'EmailAndSMS',
    "enablePointsTable" BOOLEAN NOT NULL DEFAULT true,
    "enableProgramTable" BOOLEAN NOT NULL DEFAULT true,
    "showBenefitsCarousel" BOOLEAN NOT NULL DEFAULT true,
    "rememberMeInDays" INTEGER NOT NULL DEFAULT 3,
    "defaultSmsCountryCode" TEXT NOT NULL DEFAULT 'US',
    "smsSupportedCountries" TEXT NOT NULL DEFAULT 'US,JP,IN,BR,MY,CA',
    "isArchived" BOOLEAN NOT NULL DEFAULT false,
    "verifyEmailMailTemplate" TEXT,
    "resetPasswordMailTemplate" TEXT,
    "preRegisterUser" BOOLEAN NOT NULL DEFAULT false,
    "showProgramName" BOOLEAN NOT NULL DEFAULT true,
    "useCustomMailTemplate" BOOLEAN NOT NULL DEFAULT false,
    "benefitSortBy" "BenefitSortCriteria" NOT NULL DEFAULT 'BenefitType',
    "benefitSortCriteria" JSONB,
    "themeDetails" JSONB,
    "hiddenMenuItems" TEXT[] DEFAULT ARRAY[]::TEXT[],
    "showImageOnly" BOOLEAN,
    "membershipCriteria" "MembershipCriteria",
    "localeLocaleId" TEXT,

    CONSTRAINT "Storefront_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Locale" (
    "localeId" TEXT NOT NULL,
    "countryCode" TEXT NOT NULL,
    "languageCode" TEXT NOT NULL,
    "isSupported" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Locale_pkey" PRIMARY KEY ("localeId")
);

-- CreateTable
CREATE TABLE "Benefit" (
    "id" BIGSERIAL NOT NULL,
    "redeemType" "RedeemType" NOT NULL DEFAULT 'CODE',
    "title" VARCHAR(255) NOT NULL,
    "shortDescription" VARCHAR(1024),
    "description" VARCHAR(5000) NOT NULL,
    "logoUrl" VARCHAR(750),
    "previewResourceUrl" VARCHAR(750),
    "resourceUrl" VARCHAR(750),
    "disclaimer" VARCHAR(2048),
    "type" "BenefitType" NOT NULL,
    "originalPrice" DOUBLE PRECISION,
    "discountPrice" DOUBLE PRECISION,
    "redemptionTotalLimit" INTEGER,
    "redemptionPerPass" INTEGER,
    "couponCode" VARCHAR(75),
    "discountType" "DiscountType" NOT NULL DEFAULT 'flat',
    "unlimitedRedemption" BOOLEAN NOT NULL DEFAULT false,
    "ownershipRequired" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL,
    "startDate" TIMESTAMPTZ(3),
    "endDate" TIMESTAMPTZ(3),
    "status" "BenefitStatus" NOT NULL DEFAULT 'draft',
    "activeDate" TIMESTAMPTZ(3),
    "currencyCode" TEXT,
    "currencySymbol" TEXT,
    "allowDownload" BOOLEAN NOT NULL DEFAULT false,
    "multipleResource" BOOLEAN NOT NULL DEFAULT true,
    "defaultLocaleId" TEXT NOT NULL DEFAULT 'en_US',
    "frequencyLimit" INTEGER,
    "showImagesOnly" BOOLEAN NOT NULL DEFAULT false,
    "partnerRedirectUrl" TEXT,
    "isDeleted" BOOLEAN NOT NULL DEFAULT false,
    "uniqueTransactionId" VARCHAR(555),
    "marketingCost" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "merchantExpenses" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "purchaseCost" DOUBLE PRECISION NOT NULL DEFAULT 0,

    CONSTRAINT "Benefit_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Country" (
    "countryCode" TEXT NOT NULL,
    "country" TEXT NOT NULL,

    CONSTRAINT "Country_pkey" PRIMARY KEY ("countryCode")
);

-- CreateTable
CREATE TABLE "Language" (
    "languageCode" TEXT NOT NULL,
    "language" TEXT NOT NULL,

    CONSTRAINT "Language_pkey" PRIMARY KEY ("languageCode")
);

-- CreateTable
CREATE TABLE "StorefrontLocale" (
    "id" BIGSERIAL NOT NULL,
    "storefrontId" INTEGER NOT NULL,
    "localeId" TEXT NOT NULL,
    "logoUrl" VARCHAR(1500) NOT NULL,
    "headerText" TEXT,
    "bodyText" TEXT,
    "heroBenefitsHeadline" VARCHAR(1500),
    "heroBenefitsDescription" VARCHAR(1500),
    "companyName" TEXT,
    "footerText" VARCHAR(1500),
    "websiteUrl" VARCHAR(1500),
    "twitterUrl" VARCHAR(1500),
    "discordUrl" VARCHAR(1500),
    "mediumUrl" VARCHAR(1500),
    "heroImageUrl" VARCHAR(1500),
    "heroHeadline" VARCHAR(1500),
    "heroDesc" VARCHAR(1500),
    "marketingHeadline" VARCHAR(1500),
    "marketingDesc" VARCHAR(1500),
    "pointsTableHeaderText" TEXT,
    "pointsTableBodyText" TEXT,
    "verifyEmailMailTemplate" TEXT,
    "resetPasswordMailTemplate" TEXT,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StorefrontLocale_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorefrontCollections" (
    "id" SERIAL NOT NULL,
    "storefrontId" INTEGER NOT NULL,
    "autoRegister" BOOLEAN NOT NULL DEFAULT false,
    "position" INTEGER,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StorefrontCollections_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorefrontFCMtopics" (
    "id" BIGSERIAL NOT NULL,
    "topicName" VARCHAR(500) NOT NULL,
    "storeAdminFCMToken" VARCHAR(1000),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "storefrontId" INTEGER NOT NULL,

    CONSTRAINT "StorefrontFCMtopics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorefrontHeroImages" (
    "id" SERIAL NOT NULL,
    "storefrontId" INTEGER NOT NULL,
    "imageUrl" VARCHAR(1500) NOT NULL,
    "redirectUrl" VARCHAR(1500),
    "status" "MerchantStatus" NOT NULL DEFAULT 'active',
    "startDate" TIMESTAMPTZ(3),
    "endDate" TIMESTAMPTZ(3),
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "StorefrontHeroImages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StorefrontCategoryImages" (
    "id" BIGSERIAL NOT NULL,
    "storefrontId" INTEGER NOT NULL,
    "url" VARCHAR(255) NOT NULL,

    CONSTRAINT "StorefrontCategoryImages_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "_BenefitToStorefront" (
    "A" BIGINT NOT NULL,
    "B" INTEGER NOT NULL,

    CONSTRAINT "_BenefitToStorefront_AB_pkey" PRIMARY KEY ("A","B")
);

-- CreateIndex
CREATE UNIQUE INDEX "Storefront_title_key" ON "Storefront"("title");

-- CreateIndex
CREATE UNIQUE INDEX "Storefront_cnameUrl_key" ON "Storefront"("cnameUrl");

-- CreateIndex
CREATE UNIQUE INDEX "Locale_countryCode_languageCode_key" ON "Locale"("countryCode", "languageCode");

-- CreateIndex
CREATE INDEX "Benefit_title_idx" ON "Benefit"("title");

-- CreateIndex
CREATE INDEX "Benefit_couponCode_idx" ON "Benefit"("couponCode");

-- CreateIndex
CREATE UNIQUE INDEX "Country_country_key" ON "Country"("country");

-- CreateIndex
CREATE UNIQUE INDEX "Country_countryCode_key" ON "Country"("countryCode");

-- CreateIndex
CREATE UNIQUE INDEX "Language_language_key" ON "Language"("language");

-- CreateIndex
CREATE UNIQUE INDEX "Language_languageCode_key" ON "Language"("languageCode");

-- CreateIndex
CREATE INDEX "StorefrontLocale_storefrontId_idx" ON "StorefrontLocale"("storefrontId");

-- CreateIndex
CREATE UNIQUE INDEX "StorefrontLocale_storefrontId_localeId_key" ON "StorefrontLocale"("storefrontId", "localeId");

-- CreateIndex
CREATE INDEX "StorefrontCollections_storefrontId_idx" ON "StorefrontCollections"("storefrontId");

-- CreateIndex
CREATE INDEX "StorefrontFCMtopics_storefrontId_idx" ON "StorefrontFCMtopics"("storefrontId");

-- CreateIndex
CREATE UNIQUE INDEX "StorefrontFCMtopics_topicName_key" ON "StorefrontFCMtopics"("topicName");

-- CreateIndex
CREATE INDEX "StorefrontHeroImages_storefrontId_idx" ON "StorefrontHeroImages"("storefrontId");

-- CreateIndex
CREATE INDEX "_BenefitToStorefront_B_index" ON "_BenefitToStorefront"("B");

-- AddForeignKey
ALTER TABLE "Storefront" ADD CONSTRAINT "Storefront_localeLocaleId_fkey" FOREIGN KEY ("localeLocaleId") REFERENCES "Locale"("localeId") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Locale" ADD CONSTRAINT "Locale_countryCode_fkey" FOREIGN KEY ("countryCode") REFERENCES "Country"("countryCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Locale" ADD CONSTRAINT "Locale_languageCode_fkey" FOREIGN KEY ("languageCode") REFERENCES "Language"("languageCode") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Benefit" ADD CONSTRAINT "Benefit_defaultLocaleId_fkey" FOREIGN KEY ("defaultLocaleId") REFERENCES "Locale"("localeId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontLocale" ADD CONSTRAINT "StorefrontLocale_storefrontId_fkey" FOREIGN KEY ("storefrontId") REFERENCES "Storefront"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontLocale" ADD CONSTRAINT "StorefrontLocale_localeId_fkey" FOREIGN KEY ("localeId") REFERENCES "Locale"("localeId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontCollections" ADD CONSTRAINT "StorefrontCollections_storefrontId_fkey" FOREIGN KEY ("storefrontId") REFERENCES "Storefront"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontFCMtopics" ADD CONSTRAINT "StorefrontFCMtopics_storefrontId_fkey" FOREIGN KEY ("storefrontId") REFERENCES "Storefront"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontHeroImages" ADD CONSTRAINT "StorefrontHeroImages_storefrontId_fkey" FOREIGN KEY ("storefrontId") REFERENCES "Storefront"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StorefrontCategoryImages" ADD CONSTRAINT "StorefrontCategoryImages_storefrontId_fkey" FOREIGN KEY ("storefrontId") REFERENCES "Storefront"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BenefitToStorefront" ADD CONSTRAINT "_BenefitToStorefront_A_fkey" FOREIGN KEY ("A") REFERENCES "Benefit"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "_BenefitToStorefront" ADD CONSTRAINT "_BenefitToStorefront_B_fkey" FOREIGN KEY ("B") REFERENCES "Storefront"("id") ON DELETE CASCADE ON UPDATE CASCADE;
