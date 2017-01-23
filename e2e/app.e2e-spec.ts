import { InfiniteUniversePage } from './app.po';

describe('infinite-universe App', function() {
  let page: InfiniteUniversePage;

  beforeEach(() => {
    page = new InfiniteUniversePage();
  });

  it('should display message saying app works', () => {
    page.navigateTo();
    expect(page.getParagraphText()).toEqual('app works!');
  });
});
