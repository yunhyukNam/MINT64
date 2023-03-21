#include "Page.h"

void kInitializePageTables( void ){
    PML4TENTRY* pstPML4TEntry;
    PDPTENTRY* pstPDPTEntry;
    PDENTRY* pstPDEntry;
    DWORD dwMappingAddress;

    int i;

    pstPML4TEntry = (PML4TENTRY*) 0x100000;
    kSetPageEntryData(&(pstPML4TEntry[0]), 0x00, 0x101000, PAGE_FLAGS_DEFAULT, 0);

    for(i=0;i<PAGE_MAXENTRYCOUNT;i++){
        kSetPageEntryData(&(pstPML4TEntry[i]), 0, 0, 0, 0);
    }

    pstPDPTEntry = (PDPTENTRY*) 0x101000;

    for(i = 0;i < 64;i++){
        kSetPageEntryData(&(pstPDPTEntry[i]), 0, 0x102000 + (i*PAGE_TABLESIZE), PAGE_FLAGS_DEFAULT, 0);
    }
    for(i = 64;i < PAGE_MAXENTRYCOUNT;i++){
        kSetPageEntryData(&(pstPDPTEntry[i]), 0, 0, 0, 0);
    }

    pstPDEntry = (PDENTRY*) 0x102000;
    dwMappingAddress = 0;

    for(i = 0;i < PAGE_MAXENTRYCOUNT * 64;i++){
        kSetPageEntryData(&(pstPDEntry[i]), (i*(PAGE_DEFAULTSIZE >> 20)) >> 12, dwMappingAddress, PAGE_FLAGS_DEFAULT | PAGE_FLAGS_PS, 0);
        dwMappingAddress += PAGE_DEFAULTSIZE;
    }
}

void kSetPageEntryData(PTENTRY* pstEntry, DWORD dwUpperBaseAddress, DWORD dwLowerBaseAddress, DWORD dwLowerFlags, DWORD dwUpperFlags){
    pstEntry->dwAttributeAndLowerBaseAddress = dwLowerBaseAddress | dwLowerFlags;
    pstEntry->dwUpperBaseAddressAndEXB = (dwUpperBaseAddress & 0xff) | dwUpperFlags;
}