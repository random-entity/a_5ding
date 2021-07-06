// Spawn a new random graph
void newGraph() {

  // Clear physics
  physics.clear();

  // Create new ArrayList (clears old one)
  clusters = new ArrayList();

  // Create [groupAll] random clusters
  int s = 0, t;
  int[] numbersSetting = new int[groupAll];
  for (int i = 0; i < groupAll-1; i++) {
    t = int(random(1, 10));
    numbersSetting[i] = t;
    s += t;
  }
  numbersSetting[groupAll-1] = 100-s;

  for (int i = 0; i < groupAll-1; i++) {
    Vec2D center = new Vec2D(width/2, height/2);
    clusters.add(new Cluster(numbersSetting[i], random(65, 140), center, i));
  }
  Vec2D center = new Vec2D(width/2, height/2);
  clusters.add(new Cluster(numbersSetting[groupAll-1], 200, center, groupAll-1));


  //  All clusters connect to all clusters  
  for (int i = 0; i < clusters.size(); i++) {
    for (int j = i+1; j < clusters.size(); j++) {
      Cluster ci = (Cluster) clusters.get(i);
      Cluster cj = (Cluster) clusters.get(j);
      ci.connect(cj);
    }
  }

  // Create Attractors
  attractors = new ArrayList();
  for (int i = 0; i < groupAll; i++) {
    attractors.add(new Attractor(i));
  }
}

Node getNodeByNodeNo(int i) {
  int clusterNo = 0;
  int remainder = i;
  for (int k = 0; remainder > 0; k++) {
    Cluster ck = (Cluster) clusters.get(k);
    if (remainder - ck.getNodes().size() >= 0) {
      remainder -= ck.getNodes().size();
      clusterNo++;
    } else break;
  }
  Cluster c = (Cluster) clusters.get(clusterNo);
  Node n = (Node) c.getNodes().get(remainder);
  return n;
}
