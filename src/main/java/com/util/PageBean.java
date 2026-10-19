package com.util;

import java.util.List;

public class PageBean<T> {
    private int currentPage;  // 当前页码
    private int pageSize;     // 每页记录数
    private int totalCount;   // 总记录数
    private int totalPage;    // 总页数
    private List<T> list;     // 当前页数据

    public PageBean(int currentPage, int pageSize, int totalCount, List<T> list) {
        this.currentPage = currentPage;
        this.pageSize = pageSize;
        this.totalCount = totalCount;
        this.list = list;
        this.totalPage = (int) Math.ceil((double) totalCount / pageSize);
    }

    public int getCurrentPage() { return currentPage; }
    public void setCurrentPage(int currentPage) { this.currentPage = currentPage; }
    public int getPageSize() { return pageSize; }
    public void setPageSize(int pageSize) { this.pageSize = pageSize; }
    public int getTotalCount() { return totalCount; }
    public void setTotalCount(int totalCount) { this.totalCount = totalCount; }
    public int getTotalPage() { return totalPage; }
    public void setTotalPage(int totalPage) { this.totalPage = totalPage; }
    public List<T> getList() { return list; }
    public void setList(List<T> list) { this.list = list; }

    public int getStartRow() { return (currentPage - 1) * pageSize; }
    public boolean hasPrevious() { return currentPage > 1; }
    public boolean hasNext() { return currentPage < totalPage; }
}